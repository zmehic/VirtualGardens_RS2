using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests.ProizvodiSetovi;
using VirtualGardens.Services.AllServices.ProizvodiSetovi;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProizvodiSetoviController : BaseCRUDController<Models.DTOs.ProizvodiSetDTO, ProizvodiSetSearchObject, ProizvodiSetoviUpsertRequest, ProizvodiSetoviUpsertRequest>
    {
        public ProizvodiSetoviController(IProizvodiSetoviService service) : base(service)
        {
        }
    }
}
