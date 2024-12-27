using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.HelperClasses;
using VirtualGardens.Models.Requests.KorisniciUloge;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.KorisniciUloge;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KorisniciUlogeController : BaseCRUDController<Models.DTOs.KorisniciUlogeDTO, KorisniciUlogeSearchObject, KorisniciUlogeUpsertRequest, KorisniciUlogeUpsertRequest>
    {
        public KorisniciUlogeController(IKorisniciUlogeService service) : base(service)
        {
        }

        [Authorize(Roles = "Admin")]
        public override KorisniciUlogeDTO Insert(KorisniciUlogeUpsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override KorisniciUlogeDTO Update(int id, KorisniciUlogeUpsertRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Admin")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }

        [Authorize(Roles = "Admin")]
        public override KorisniciUlogeDTO GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Admin")]
        public override PagedResult<KorisniciUlogeDTO> GetList([FromQuery] KorisniciUlogeSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
    }
}
