using MapsterMapper;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
        public JediniceMjereService(_210011Context context, IMapper mapper) : base(context, mapper)
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

            return query;
        }
    }
}
