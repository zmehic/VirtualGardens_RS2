using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests.Recenzije;
using VirtualGardens.Models.Requests.SetoviPonude;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.Recenzije;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.SetoviPonude
{
    public class SetoviPonudeService : BaseCRUDService<Models.DTOs.SetoviPonudeDTO, SetoviPonudeSearchObject, Database.SetoviPonude, SetoviPonudeUpsertRequest, SetoviPonudeUpsertRequest>, ISetoviPonudeService
    {
        public SetoviPonudeService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.SetoviPonude> AddFilter(SetoviPonudeSearchObject search, IQueryable<Database.SetoviPonude> query)
        {

            if (search.SetId.HasValue)
            {
                query = query.Where(x => x.SetId == search.SetId.Value);
            }

            if (search.PonudaId.HasValue)
            {
                query = query.Where(x => x.PonudaId == search.PonudaId.Value);
            }

            return query;
        }

    }
}
