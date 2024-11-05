using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Setovi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.Setovi
{
    public class SetoviService : BaseCRUDService<Models.DTOs.SetoviDTO, SetoviSearchObject, Database.Setovi, SetoviUpsertRequest, SetoviUpsertRequest>, ISetoviService
    {
        public SetoviService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Setovi> AddFilter(SetoviSearchObject search, IQueryable<Database.Setovi> query)
        {
            if (search.CijenaFrom.HasValue)
            {
                query = query.Where(x => x.Cijena >= search.CijenaFrom.Value);
            }

            if (search.CijenaTo.HasValue)
            {
                query = query.Where(x => x.Cijena <= search.CijenaTo.Value);
            }

            if (search.PopustFrom.HasValue)
            {
                query = query.Where(x => x.Popust >= search.PopustFrom.Value);
            }

            if (search.PopustTo.HasValue)
            {
                query = query.Where(x => x.Popust <= search.PopustTo.Value);
            }

            if (search.NarudzbaId.HasValue)
            {
                query = query.Where(x => x.NarudzbaId == search.NarudzbaId.Value);
            }

            if (search.CijenaSaPopustomFrom.HasValue)
            {
                query = query.Where(x => x.CijenaSaPopustom >= search.CijenaSaPopustomFrom.Value);
            }

            if (search.CijenaSaPopustomTo.HasValue)
            {
                query = query.Where(x => x.CijenaSaPopustom <= search.CijenaSaPopustomTo.Value);
            }

            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }

            return query;
        }

    }
}
