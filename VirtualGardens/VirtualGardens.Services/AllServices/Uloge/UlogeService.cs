using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Uloge;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.Uloge
{
    public class UlogeService : BaseCRUDService<Models.DTOs.UlogeDTO, UlogeSearchObject, Database.Uloge, UlogeInsertRequest, UlogeUpdateRequest>, IUlogeService
    {
        public UlogeService(_210011Context _context, IMapper _mapper) : base(_context, _mapper)
        {
        }

        public override IQueryable<Services.Database.Uloge> AddFilter(UlogeSearchObject search, IQueryable<Services.Database.Uloge> query)
        {
            if (!string.IsNullOrEmpty(search?.NazivGTE))
            {
                query = query.Where(x => x.Naziv.ToLower().StartsWith(search.NazivGTE.ToLower()));
            }
            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }
            return query;
        }
    }
}
