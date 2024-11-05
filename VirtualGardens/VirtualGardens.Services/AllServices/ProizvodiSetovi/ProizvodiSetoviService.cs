using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.ProizvodiSetovi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.ProizvodiSetovi
{
    public class ProizvodiSetoviService : BaseCRUDService<Models.DTOs.ProizvodiSetDTO, ProizvodiSetSearchObject, Database.ProizvodiSet, ProizvodiSetoviUpsertRequest, ProizvodiSetoviUpsertRequest>, IProizvodiSetoviService
    {
        public ProizvodiSetoviService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.ProizvodiSet> AddFilter(ProizvodiSetSearchObject search, IQueryable<Database.ProizvodiSet> query)
        {
            if (search.ProizvodId.HasValue)
            {
                query = query.Where(x => x.ProizvodId == search.ProizvodId.Value);
            }

            if (search.SetId.HasValue)
            {
                query = query.Where(x => x.SetId == search.SetId.Value);
            }

            if (search.KolicinaFrom.HasValue)
            {
                query = query.Where(x => x.Kolicina >= search.KolicinaFrom.Value);
            }

            if (search.KolicinaTo.HasValue)
            {
                query = query.Where(x => x.Kolicina <= search.KolicinaTo.Value);
            }

            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }

            return query;
        }

    }
}
