using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests.Proizvodi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.ProizvodiNoImage
{
    public class ProizvodiNoImageService : BaseService<Models.DTOs.ProizvodiNoImageDTO, ProizvodiSearchObject, Database.Proizvodi>, IProizvodiNoImageService
    {
        public ProizvodiNoImageService(_210011Context _context, IMapper _mapper) : base(_context, _mapper)
        {

        }

        public override IQueryable<Services.Database.Proizvodi> AddFilter(ProizvodiSearchObject search, IQueryable<Services.Database.Proizvodi> query)
        {
            if (!string.IsNullOrEmpty(search.NazivGTE))
            {
                query = query.Where(x => x.Naziv.ToLower().StartsWith(search.NazivGTE.ToLower()));
            }

            if (search.CijenaFrom.HasValue)
            {
                query = query.Where(x => x.Cijena >= search.CijenaFrom.Value);
            }

            if (search.CijenaTo.HasValue)
            {
                query = query.Where(x => x.Cijena <= search.CijenaTo.Value);
            }

            if (search.DostupnaKolicinaFrom.HasValue)
            {
                query = query.Where(x => x.DostupnaKolicina >= search.DostupnaKolicinaFrom.Value);
            }

            if (search.DostupnaKolicinaTo.HasValue)
            {
                query = query.Where(x => x.DostupnaKolicina <= search.DostupnaKolicinaTo.Value);
            }

            if (search.JedinicaMjereId.HasValue)
            {
                query = query.Where(x => x.JedinicaMjereId == search.JedinicaMjereId.Value);
            }

            if (search.VrstaProizvodaId.HasValue)
            {
                query = query.Where(x => x.VrstaProizvodaId == search.VrstaProizvodaId.Value);
            }
            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }

            return query;
        }
    }
}
