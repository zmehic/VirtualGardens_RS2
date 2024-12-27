using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.HelperClasses;
using VirtualGardens.Models.Requests.Ulazi;
using VirtualGardens.Models.Requests.UlaziProizvodi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.UlaziProizvodi;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UlaziProizvodiController : BaseCRUDController<Models.DTOs.UlaziProizvodiDTO, UlaziProizvodiSearchObject, UlaziProizvodiUpsertRequest, UlaziProizvodiUpsertRequest>
    {
        public UlaziProizvodiController(IUlaziProizvodiService service) : base(service)
        {
        }

        [Authorize(Roles = "Admin")]
        public override UlaziProizvodiDTO GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Admin")]
        public override PagedResult<UlaziProizvodiDTO> GetList([FromQuery] UlaziProizvodiSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Admin")]
        public override UlaziProizvodiDTO Insert(UlaziProizvodiUpsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override UlaziProizvodiDTO Update(int id, UlaziProizvodiUpsertRequest request)
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
