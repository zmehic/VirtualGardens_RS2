using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests.Nalozi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.Nalozi
{
    public interface INaloziService : ICRUDService<Models.DTOs.NaloziDTO, NaloziSearchObject, NaloziInsertRequest, NaloziUpdateRequest>
    {
    }
}
