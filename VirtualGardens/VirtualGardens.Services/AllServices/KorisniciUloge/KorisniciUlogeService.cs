using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.KorisniciUloge;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.KorisniciUloge
{
    public class KorisniciUlogeService : BaseCRUDService<Models.DTOs.KorisniciUlogeDTO, KorisniciUlogeSearchObject, Database.KorisniciUloge, KorisniciUlogeUpsertRequest, KorisniciUlogeUpsertRequest>, IKorisniciUlogeService
    {
        public KorisniciUlogeService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
