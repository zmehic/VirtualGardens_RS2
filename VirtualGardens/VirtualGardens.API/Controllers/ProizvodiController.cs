using Microsoft.AspNetCore.Mvc;
using VirtualGardens.Services.Database;
using VirtualGardens.Services;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Models.Requests.Proizvodi;
using VirtualGardens.Services.BaseInterfaces;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.HelperClasses;
using Microsoft.AspNetCore.Authorization;
using VirtualGardens.Services.AllServices;

namespace VirtualGardens.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProizvodiController : BaseCRUDController<Models.DTOs.ProizvodiDTO, ProizvodiSearchObject, ProizvodiUpsertRequest, ProizvodiUpsertRequest>
    {
        public ProizvodiController(IProizvodiService service) : base(service)
        {
        }

        [Authorize(Roles = "Admin,Kupac")]
        public override PagedResult<ProizvodiDTO> GetList([FromQuery] ProizvodiSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Admin,Kupac")]
        public override ProizvodiDTO GetById(int id)
        {
            return base.GetById(id);
        }

        [HttpPut("recalculate")]
        [Authorize(Roles = "Admin")]
        public IActionResult RecalculateQuantity()
        {
            if((_service as IProizvodiService).RecalcuclateQuantity())
            {
                return Ok();
            }
            else { return BadRequest(); }
        }
    }
}
