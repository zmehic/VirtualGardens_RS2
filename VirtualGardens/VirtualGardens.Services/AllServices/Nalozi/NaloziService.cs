using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests.Nalozi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.Nalozi
{
    public class NaloziService : BaseCRUDService<Models.DTOs.NaloziDTO, NaloziSearchObject, Database.Nalozi, NaloziInsertRequest, NaloziUpdateRequest>, INaloziService
    {
        public NaloziService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Services.Database.Nalozi> AddFilter(NaloziSearchObject search, IQueryable<Database.Nalozi> query)
        {
            if (!string.IsNullOrEmpty(search?.BrojNalogaGTE))
            {
                query = query.Where(x => x.BrojNaloga.ToLower().StartsWith(search.BrojNalogaGTE.ToLower()));
            }

            if (search.DatumKreiranjaFrom.HasValue)
            {
                query = query.Where(x => x.DatumKreiranja >= search.DatumKreiranjaFrom.Value);
            }

            if (search.DatumKreiranjaTo.HasValue)
            {
                query = query.Where(x => x.DatumKreiranja <= search.DatumKreiranjaTo.Value);
            }

            if (search.ZaposlenikId.HasValue)
            {
                query = query.Where(x => x.ZaposlenikId == search.ZaposlenikId.Value);
            }

            if (search.Zavrsen.HasValue)
            {
                query = query.Where(x => x.Zavrsen == search.Zavrsen.Value);
            }

            return query;
        }
    }
}
