using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.HelperClasses;
using VirtualGardens.Models.Requests.Uloge;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.Uloge;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class UlogeController : BaseCRUDController<Models.DTOs.UlogeDTO, UlogeSearchObject, UlogeInsertRequest, UlogeUpdateRequest>
    {
        public UlogeController(IUlogeService service) : base(service)
        {
        }

        [Authorize(Roles = "Admin")]
        public override PagedResult<UlogeDTO> GetList([FromQuery] UlogeSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Admin")]
        public override UlogeDTO GetById(int id)
        {
            return base.GetById(id);
        }
    }
}
