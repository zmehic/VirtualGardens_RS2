using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Exceptions;
using VirtualGardens.Models.Requests.VrsteProizvoda;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.VrsteProizvoda
{
    public class VrsteProizvodaService : BaseCRUDService<Models.DTOs.VrsteProizvodaDTO, VrsteProizvodaSearchObject, Database.VrsteProizvodum, VrsteProizvodaUpsertRequest, VrsteProizvodaUpsertRequest>, IVrsteProizvodaService
    {
        public VrsteProizvodaService(_210011Context _context, IMapper _mapper) : base(_context, _mapper)
        {
        }

        public override IQueryable<Services.Database.VrsteProizvodum> AddFilter(VrsteProizvodaSearchObject search, IQueryable<Services.Database.VrsteProizvodum> query)
        {
            if (!string.IsNullOrEmpty(search?.NazivGTE))
            {
                query = query.Where(x => x.Naziv.ToLower().StartsWith(search.NazivGTE.ToLower()));
            }

            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }
            return query;
        }

        public override VrsteProizvodaDTO Update(int id, VrsteProizvodaUpsertRequest request)
        {
            var set = context.Set<VrsteProizvodum>();
            var entity = set.Find(id);

            BeforeUpdate(request, entity);

            mapper.Map(request, entity);

            context.SaveChanges();

            AfterUpdate(request, entity);

            return mapper.Map<VrsteProizvodaDTO>(entity);
        }

        public override void BeforeUpdate(VrsteProizvodaUpsertRequest request, VrsteProizvodum entity)
        {
            if (entity.Naziv == "Tlo" || entity.Naziv == "Sjeme" || entity.Naziv == "Prihrana")
            {
                throw new UserException("Ovo je bazna vrsta proizvoda i nije je moguće uređivati");
            }

            var vrstaProizvoda = context.VrsteProizvoda.Where(x => x.IsDeleted == false && x.Naziv == request.Naziv).FirstOrDefault();
            if (vrstaProizvoda != null && vrstaProizvoda.Naziv != entity.Naziv)
            {
                throw new UserException("Već postoji vrsta proizvoda sa tim nazivom");
            }
            base.BeforeUpdate(request, entity);
        }

        public override void BeforeInsert(VrsteProizvodaUpsertRequest request, VrsteProizvodum entity)
        {
            var vrstaProizvoda = context.VrsteProizvoda.Where(x => x.IsDeleted == false && x.Naziv == request.Naziv).FirstOrDefault();
            if (vrstaProizvoda != null)
            {
                throw new UserException("Već postoji jedinica mjere sa tim nazivom");
            }
            base.BeforeInsert(request, entity);
        }

        public override void BeforeDelete(int id, VrsteProizvodum entity)
        {
            if (entity.Naziv == "Tlo" || entity.Naziv == "Sjeme" || entity.Naziv == "Prihrana")
            {
                throw new UserException("Ovo je bazna vrsta proizvoda i nije je moguće brisati");
            }
            base.BeforeDelete(id, entity);
        }
    }
}
