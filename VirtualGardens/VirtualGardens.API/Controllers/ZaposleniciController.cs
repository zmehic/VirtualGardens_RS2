using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests.Zaposlenici;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.Zaposlenici;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ZaposleniciController : BaseCRUDController<Models.DTOs.ZaposleniciDTO, ZaposleniciSearchObject, ZaposleniciInsertRequest, ZaposleniciUpdateRequest>
    {
        public ZaposleniciController(IZaposleniciService service) : base(service)
        {
        }
    }
}
