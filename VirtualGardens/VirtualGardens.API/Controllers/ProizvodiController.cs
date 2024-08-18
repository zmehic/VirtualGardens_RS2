using Microsoft.AspNetCore.Mvc;
using VirtualGardens.Services.Database;
using VirtualGardens.Services;

namespace VirtualGardens.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProizvodiController:ControllerBase
    {
        protected IProizvodiService _service;

        public ProizvodiController(IProizvodiService service)
        {
            _service = service;
        }

        [HttpGet]
        public List<Proizvodi> GetList()
        {
            return _service.GetList();
        }
    }
}
