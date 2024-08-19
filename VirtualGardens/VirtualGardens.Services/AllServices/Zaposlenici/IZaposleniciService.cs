using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Zaposlenici;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.Zaposlenici
{
    public interface IZaposleniciService : ICRUDService<Models.DTOs.ZaposleniciDTO, ZaposleniciSearchObject, ZaposleniciInsertRequest, ZaposleniciUpdateRequest>
    {

    }
}
