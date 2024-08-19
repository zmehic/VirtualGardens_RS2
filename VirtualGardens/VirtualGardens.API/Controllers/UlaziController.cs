using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests.Proizvodi;
using VirtualGardens.Models.Requests.Ulazi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.Ulazi;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UlaziController : BaseCRUDController<Models.DTOs.UlaziDTO, UlaziSearchObject, UlaziUpsertRequest, UlaziUpsertRequest>
    {
        public UlaziController(IUlaziService service) : base(service)
        {
        }
    }
}
