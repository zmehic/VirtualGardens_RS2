using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.Narudzbe
{
    public class NarudzbeService : BaseCRUDService<Models.DTOs.NarudzbeDTO, NarudzbeSearchObject, Database.Narudzbe, NarudzbeUpsertRequest, NarudzbeUpsertRequest>, INarudzbeService
    {
        public NarudzbeService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Narudzbe> AddFilter(NarudzbeSearchObject search, IQueryable<Database.Narudzbe> query)
        {
            if (!string.IsNullOrEmpty(search?.BrojNarudzbeGTE))
            {
                query = query.Where(x => x.BrojNarudzbe.ToLower().StartsWith(search.BrojNarudzbeGTE.ToLower()));
            }

            if (search.Otkazana.HasValue)
            {
                query = query.Where(x => x.Otkazana == search.Otkazana.Value);
            }

            if (search.DatumFrom.HasValue)
            {
                query = query.Where(x => x.Datum >= search.DatumFrom.Value);
            }

            if (search.DatumTo.HasValue)
            {
                query = query.Where(x => x.Datum <= search.DatumTo.Value);
            }

            if (search.Placeno.HasValue)
            {
                query = query.Where(x => x.Placeno == search.Placeno.Value);
            }

            if (search.Status.HasValue)
            {
                query = query.Where(x => x.Status == search.Status.Value);
            }

            if (search.UkupnaCijenaFrom.HasValue)
            {
                query = query.Where(x => x.UkupnaCijena >= search.UkupnaCijenaFrom.Value);
            }

            if (search.UkupnaCijenaTo.HasValue)
            {
                query = query.Where(x => x.UkupnaCijena <= search.UkupnaCijenaTo.Value);
            }

            if (search.KorisnikId.HasValue)
            {
                query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);
            }

            if (search.NalogId.HasValue)
            {
                query = query.Where(x => x.NalogId == search.NalogId.Value);
            }

            return query;
        }
    }
}
