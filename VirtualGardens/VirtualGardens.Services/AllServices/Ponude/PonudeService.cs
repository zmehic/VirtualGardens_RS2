using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Ponude;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.Ponude
{
    public class PonudeService : BaseCRUDService<Models.DTOs.PonudeDTO, PonudeSearchObject, Database.Ponude, PonudeUpsertRequest, PonudeUpsertRequest>, IPonudeService
    {
        public PonudeService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Ponude> AddFilter(PonudeSearchObject search, IQueryable<Database.Ponude> query)
        {

            if (!string.IsNullOrEmpty(search.NazivContains))
            {
                query = query.Where(x => x.Naziv.ToLower().Contains(search.NazivContains.ToLower()));
            }

            if (search.PopustFrom.HasValue)
            {
                query = query.Where(x => x.Popust >= search.PopustFrom.Value);
            }

            if (search.PopustTo.HasValue)
            {
                query = query.Where(x => x.Popust <= search.PopustTo.Value);
            }


            return query;
        }

    }
}
