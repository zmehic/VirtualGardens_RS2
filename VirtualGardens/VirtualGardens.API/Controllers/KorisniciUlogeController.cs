using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests.KorisniciUloge;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.KorisniciUloge;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KorisniciUlogeController : BaseCRUDController<Models.DTOs.KorisniciUlogeDTO, KorisniciUlogeSearchObject, KorisniciUlogeUpsertRequest, KorisniciUlogeUpsertRequest>
    {
        public KorisniciUlogeController(IKorisniciUlogeService service) : base(service)
        {
        }
    }
}
