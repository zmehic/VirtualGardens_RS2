using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.HelperClasses;
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

        [Authorize(Roles = "Admin")]
        public override PagedResult<UlaziDTO> GetList([FromQuery] UlaziSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Admin")]
        public override UlaziDTO GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Admin")]
        public override UlaziDTO Insert(UlaziUpsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override UlaziDTO Update(int id, UlaziUpsertRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Admin")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }
    }
}
