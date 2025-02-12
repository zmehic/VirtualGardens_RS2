using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Setovi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.Setovi
{
    public interface ISetoviService : ICRUDService<Models.DTOs.SetoviDTO, SetoviSearchObject, SetoviUpsertRequest, SetoviUpsertRequest>
    {
    }
}
