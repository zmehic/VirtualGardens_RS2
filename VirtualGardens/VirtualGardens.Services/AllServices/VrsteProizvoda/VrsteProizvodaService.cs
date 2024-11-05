using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests.VrsteProizvoda;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.VrsteProizvoda
{
    public class VrsteProizvodaService : BaseCRUDService<Models.DTOs.VrsteProizvodaDTO, VrsteProizvodaSearchObject, Database.VrsteProizvodum, VrsteProizvodaUpsertRequest, VrsteProizvodaUpsertRequest>, IVrsteProizvodaService
    {
        public VrsteProizvodaService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Services.Database.VrsteProizvodum> AddFilter(VrsteProizvodaSearchObject search, IQueryable<Services.Database.VrsteProizvodum> query)
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
