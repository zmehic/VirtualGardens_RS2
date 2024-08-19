using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.KorisniciUloge;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.KorisniciUloge
{
    public interface IKorisniciUlogeService : ICRUDService<Models.DTOs.KorisniciUlogeDTO, KorisniciUlogeSearchObject, KorisniciUlogeUpsertRequest, KorisniciUlogeUpsertRequest>
    {
    }
}
