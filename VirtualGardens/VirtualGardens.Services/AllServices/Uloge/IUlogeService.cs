using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Uloge;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.Uloge
{
    public interface IUlogeService : ICRUDService<Models.DTOs.UlogeDTO, UlogeSearchObject, UlogeInsertRequest, UlogeUpdateRequest>
    {
    }
}
