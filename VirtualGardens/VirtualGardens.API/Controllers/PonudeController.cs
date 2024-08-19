using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests.Ponude;
using VirtualGardens.Models.Requests.VrsteProizvoda;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.Ponude;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PonudeController : BaseCRUDController<PonudeDTO, PonudeSearchObject, PonudeUpsertRequest, PonudeUpsertRequest>
    {
        public PonudeController(IPonudeService service) : base(service)
        {
        }
    }
}
