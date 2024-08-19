using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Ulazi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.Ulazi
{
    public interface IUlaziService : ICRUDService<Models.DTOs.UlaziDTO, UlaziSearchObject, UlaziUpsertRequest, UlaziUpsertRequest>
    {
    }
}
