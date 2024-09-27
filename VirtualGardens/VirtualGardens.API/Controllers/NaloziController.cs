using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.HelperClasses;
using VirtualGardens.Models.Requests.JediniceMjere;
using VirtualGardens.Models.Requests.Nalozi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.Nalozi;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NaloziController : BaseCRUDController<Models.DTOs.NaloziDTO, NaloziSearchObject, NaloziInsertRequest, NaloziUpdateRequest>
    {
        public NaloziController(INaloziService service) : base(service)
        {
        }

        [Authorize(Roles = "Admin")]
        public override NaloziDTO GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Admin")]
        public override PagedResult<NaloziDTO> GetList([FromQuery] NaloziSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
    }
}
