using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.PitanjaOdgovori;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.PitanjaOdgovori
{
    public class PitanjaOdgovoriService : BaseCRUDService<Models.DTOs.PitanjaOdgovoriDTO, PitanjaOdgovoriSearchObject, Database.PitanjaOdgovori, PitanjaOdgovoriUpsertRequest, PitanjaOdgovoriUpsertRequest>, IPitanjaOdgovoriService
    {
        public PitanjaOdgovoriService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.PitanjaOdgovori> AddFilter(PitanjaOdgovoriSearchObject search, IQueryable<Database.PitanjaOdgovori> query)
        {
            if (search.DatumFrom.HasValue)
            {
                query = query.Where(x => x.Datum >= search.DatumFrom.Value);
            }

            if (search.DatumTo.HasValue)
            {
                query = query.Where(x => x.Datum <= search.DatumTo.Value);
            }

            if (search.KorisnikId.HasValue)
            {
                query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);
            }

            if (search.NarudzbaId.HasValue)
            {
                query = query.Where(x => x.NarudzbaId == search.NarudzbaId.Value);
            }

            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }

            return query;
        }

    }
}
