using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Recenzije;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.Recenzije
{
    public class RecenzijeService : BaseCRUDService<Models.DTOs.RecenzijeDTO, RecenzijeSearchObject, Database.Recenzije, RecenzijeUpsertRequest, RecenzijeUpsertRequest>, IRecenzijeService
    {
        public RecenzijeService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Recenzije> AddFilter(RecenzijeSearchObject search, IQueryable<Database.Recenzije> query)
        {
            if (search.OcjenaFrom.HasValue)
            {
                query = query.Where(x => x.Ocjena >= search.OcjenaFrom.Value);
            }

            if (search.OcjenaTo.HasValue)
            {
                query = query.Where(x => x.Ocjena <= search.OcjenaTo.Value);
            }

            if (search.KorisnikId.HasValue)
            {
                query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);
            }

            if (search.DatumFrom.HasValue)
            {
                query = query.Where(x => x.Datum >= search.DatumFrom.Value);
            }

            if (search.DatumTo.HasValue)
            {
                query = query.Where(x => x.Datum <= search.DatumTo.Value);
            }

            if (search.ProizvodId.HasValue)
            {
                query = query.Where(x => x.ProizvodId == search.ProizvodId.Value);
            }

            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }

            return query;
        }

    }
}
