using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Zaposlenici;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.Zaposlenici
{
    public class ZaposleniciService : BaseCRUDService<Models.DTOs.ZaposleniciDTO, ZaposleniciSearchObject, Database.Zaposlenici, ZaposleniciInsertRequest, ZaposleniciUpdateRequest>, IZaposleniciService
    {
        public ZaposleniciService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Services.Database.Zaposlenici> AddFilter(ZaposleniciSearchObject search, IQueryable<Services.Database.Zaposlenici> query)
        {
            if (!string.IsNullOrEmpty(search?.ImeGTE))
            {
                query = query.Where(x => x.Ime.ToLower().StartsWith(search.ImeGTE.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.PrezimeGTE))
            {
                query = query.Where(x => x.Prezime.ToLower().StartsWith(search.PrezimeGTE.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.BrojTelefona))
            {
                query = query.Where(x => x.BrojTelefona == search.BrojTelefona);
            }

            if (!string.IsNullOrEmpty(search?.AdresaGTE))
            {
                query = query.Where(x => x.Adresa.ToLower().StartsWith(search.AdresaGTE.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.GradGTE))
            {
                query = query.Where(x => x.Grad.ToLower().StartsWith(search.GradGTE.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.DrzavaGTE))
            {
                query = query.Where(x => x.Drzava.ToLower().StartsWith(search.DrzavaGTE.ToLower()));
            }

            if (search?.JeAktivan.HasValue == true)
            {
                query = query.Where(x => x.JeAktivan == search.JeAktivan.Value);
            }

            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }

            return query;
        }
    }
}
