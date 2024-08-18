using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KorisniciController : BaseCRUDController<Models.DTOs.KorisniciDTO, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        public KorisniciController(IKorisniciService service) : base(service)
        {
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public Models.DTOs.KorisniciDTO Login(string username, string password)
        {
            return (_service as IKorisniciService).Login(username, password);
        }
    }
}
