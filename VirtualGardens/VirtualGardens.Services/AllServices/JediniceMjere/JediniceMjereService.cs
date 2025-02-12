using MapsterMapper;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Exceptions;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.JediniceMjere;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.Auth;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.JediniceMjere
{
    public class JediniceMjereService : BaseCRUDService<Models.DTOs.JediniceMjereDTO, JediniceMjereSearchObject, Database.JediniceMjere, JediniceMjereUpsertRequest, JediniceMjereUpsertRequest>, IJediniceMjereService
    {
        public JediniceMjereService(_210011Context _context, IMapper _mapper) : base(_context, _mapper)
        {
        }

        public override IQueryable<Services.Database.JediniceMjere> AddFilter(JediniceMjereSearchObject search, IQueryable<Services.Database.JediniceMjere> query)
        {
            if (!string.IsNullOrEmpty(search?.NazivGTE))
            {
                query = query.Where(x => x.Naziv.ToLower().StartsWith(search.NazivGTE.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.SkracenicaGTE))
            {
                query = query.Where(x => x.Skracenica.ToLower().StartsWith(search.SkracenicaGTE.ToLower()));
            }

            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }

            return query;
        }

        public override void BeforeInsert(JediniceMjereUpsertRequest request, Database.JediniceMjere entity)
        {
            var jedinicaMjere = context.JediniceMjeres.Where(x => x.IsDeleted == false && x.Naziv == request.Naziv).FirstOrDefault();
            if (jedinicaMjere != null)
            {
                throw new UserException("Već postoji jedinica mjere sa tim nazivom");
            }
        }

        public override void BeforeUpdate(JediniceMjereUpsertRequest request, Database.JediniceMjere entity)
        {
            var jedinicaMjere = context.JediniceMjeres.Where(x => x.IsDeleted == false && x.Naziv == request.Naziv).FirstOrDefault();
            if (jedinicaMjere != null && jedinicaMjere.Naziv != entity.Naziv)
            {
                throw new UserException("Već postoji jedinica mjere sa tim nazivom");
            }
        }
    }
}
