using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.UlaziProizvodi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.UlaziProizvodi
{
    public class UlaziProizvodiService : BaseCRUDService<Models.DTOs.UlaziProizvodiDTO, UlaziProizvodiSearchObject, Database.UlaziProizvodi, UlaziProizvodiUpsertRequest, UlaziProizvodiUpsertRequest>, IUlaziProizvodiService
    {
        public UlaziProizvodiService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.UlaziProizvodi> AddFilter(UlaziProizvodiSearchObject search, IQueryable<Database.UlaziProizvodi> query)
        {
            if (search.UlazId.HasValue)
            {
                // Filter by UlazId (Entry ID)
                query = query.Where(x => x.UlazId == search.UlazId.Value);
            }

            if (search.ProizvodId.HasValue)
            {
                // Filter by ProizvodId (Product ID)
                query = query.Where(x => x.ProizvodId == search.ProizvodId.Value);
            }

            if (search.KolicinaFrom.HasValue)
            {
                // Filter by Kolicina (Quantity) - greater than or equal to specified value
                query = query.Where(x => x.Kolicina >= search.KolicinaFrom.Value);
            }

            if (search.KolicinaTo.HasValue)
            {
                // Filter by Kolicina (Quantity) - less than or equal to specified value
                query = query.Where(x => x.Kolicina <= search.KolicinaTo.Value);
            }

            return query;
        }

    }
}
