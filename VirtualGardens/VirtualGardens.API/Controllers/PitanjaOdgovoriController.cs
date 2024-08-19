using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.PitanjaOdgovori;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.PitanjaOdgovori;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PitanjaOdgovoriController : BaseCRUDController<Models.DTOs.PitanjaOdgovoriDTO, PitanjaOdgovoriSearchObject, PitanjaOdgovoriUpsertRequest, PitanjaOdgovoriUpsertRequest>
    {
        public PitanjaOdgovoriController(IPitanjaOdgovoriService service) : base(service)
        {
        }
    }
}
