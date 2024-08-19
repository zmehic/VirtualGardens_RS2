using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Models.Requests.SetoviPonude;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.SetoviPonude;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SetoviPonudeController : BaseCRUDController<Models.DTOs.SetoviPonudeDTO, SetoviPonudeSearchObject, SetoviPonudeUpsertRequest, SetoviPonudeUpsertRequest>
    {
        public SetoviPonudeController(ISetoviPonudeService service) : base(service)
        {
        }
    }
}
