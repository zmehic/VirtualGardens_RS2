using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Exceptions;
using VirtualGardens.Models.Requests.Nalozi;
using VirtualGardens.Models.Requests.Ulazi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.Nalozi
{
    public class NaloziService : BaseCRUDService<Models.DTOs.NaloziDTO, NaloziSearchObject, Database.Nalozi, NaloziInsertRequest, NaloziUpdateRequest>, INaloziService
    {
        public NaloziService(_210011Context _context, IMapper _mapper) : base(_context, _mapper)
        {
        }

        public override IQueryable<Services.Database.Nalozi> AddFilter(NaloziSearchObject search, IQueryable<Database.Nalozi> query)
        {
            if (!string.IsNullOrEmpty(search?.BrojNalogaGTE))
            {
                query = query.Where(x => x.BrojNaloga.ToLower().StartsWith(search.BrojNalogaGTE.ToLower()));
            }
            if(search != null)
            {
                if (search.DatumKreiranjaFrom.HasValue)
                {
                    query = query.Where(x => x.DatumKreiranja >= search.DatumKreiranjaFrom.Value);
                }

                if (search.DatumKreiranjaTo.HasValue)
                {
                    query = query.Where(x => x.DatumKreiranja <= search.DatumKreiranjaTo.Value);
                }

                if (search.ZaposlenikId.HasValue)
                {
                    query = query.Where(x => x.ZaposlenikId == search.ZaposlenikId.Value);
                }

                if (search.Zavrsen.HasValue)
                {
                    query = query.Where(x => x.Zavrsen == search.Zavrsen.Value);
                }

                if (search?.isDeleted != null)
                {
                    query = query.Where(x => x.IsDeleted == search.isDeleted);
                }
            }

            return query;
        }

        public override NaloziDTO Insert(NaloziInsertRequest request)
        {
            int? lastNumber;
            if (!context.Narudzbes.Any())
            {
                lastNumber = 0;
            }
            else
            {
                var lastOrderNumberSplit = (context.Nalozis.OrderBy(x => x.NalogId).Last().BrojNaloga).Split('-');
                lastNumber = Int32.Parse(lastOrderNumberSplit[1]);
            }
            request.BrojNaloga = $"NAL-{lastNumber + 1}";
            return base.Insert(request);
        }

        public override void BeforeDelete(int id, Database.Nalozi entity)
        {
            var nalog = context.Nalozis.Where(x => x.NalogId == entity.NalogId).Include(x => x.Narudzbes).FirstOrDefault();
            if (nalog.Narudzbes != null && nalog.Narudzbes.Count >0)
                throw new UserException("Prije brisanja uklonite sve narudžbe iz naloga");
        }
    }
}
