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
        public UlaziService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Ulazi> AddFilter(UlaziSearchObject search, IQueryable<Database.Ulazi> query)
        {
            if (!string.IsNullOrEmpty(search.BrojUlazaGTE))
            {
                // Filter by entry number where it starts with the provided string
                query = query.Where(x => x.BrojUlaza.ToLower().StartsWith(search.BrojUlazaGTE.ToLower()));
            }

            if (search.DatumUlazaFrom.HasValue)
            {
                // Filter by entry date starting from the provided date
                query = query.Where(x => x.DatumUlaza >= search.DatumUlazaFrom.Value);
            }

            if (search.DatumUlazaTo.HasValue)
            {
                // Filter by entry date up to the provided date
                query = query.Where(x => x.DatumUlaza <= search.DatumUlazaTo.Value);
            }

            if (search.KorisnikId.HasValue)
            {
                // Filter by user ID
                query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);
            }

            return query;
        }
    }
}
