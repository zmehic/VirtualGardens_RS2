using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Ulazi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.Ulazi
{
    public class UlaziService : BaseCRUDService<Models.DTOs.UlaziDTO, UlaziSearchObject, Database.Ulazi, UlaziUpsertRequest, UlaziUpsertRequest>, IUlaziService
    {
        public UlaziService(_210011Context _context, IMapper _mapper) : base(_context, _mapper)
        {
        }

        public override IQueryable<Database.Ulazi> AddFilter(UlaziSearchObject search, IQueryable<Database.Ulazi> query)
        {
            if (!string.IsNullOrEmpty(search.BrojUlazaGTE))
            {
                query = query.Where(x => x.BrojUlaza.ToLower().StartsWith(search.BrojUlazaGTE.ToLower()));
            }

            if (search.DatumUlazaFrom.HasValue)
            {
                query = query.Where(x => x.DatumUlaza >= search.DatumUlazaFrom.Value);
            }

            if (search.DatumUlazaTo.HasValue)
            {
                query = query.Where(x => x.DatumUlaza <= search.DatumUlazaTo.Value);
            }

            if (search.KorisnikId.HasValue)
            {
                query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);
            }

            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }

            return query;
        }

        public override void AfterDelete(int id, Database.Ulazi entity)
        {
            var ulaziProizvodi = context.Set<VirtualGardens.Services.Database.UlaziProizvodi>().Where(x => x.UlazId == id && x.IsDeleted==false).ToList();

            foreach (var item in ulaziProizvodi)
            {
                var proizvod = context.Set<Database.Proizvodi>().Find(item.ProizvodId);
                if(proizvod!=null)
                {
                    proizvod.DostupnaKolicina -= item.Kolicina;
                    context.Update<Database.Proizvodi>(proizvod);
                }

            }
            context.SaveChanges();
        }
    }
}
