using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.HelperClasses;
using VirtualGardens.Models.Requests.VrsteProizvoda;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.VrsteProizvoda;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VrsteProizvodaController : BaseCRUDController<Models.DTOs.VrsteProizvodaDTO, VrsteProizvodaSearchObject, VrsteProizvodaUpsertRequest, VrsteProizvodaUpsertRequest>
    {
        public VrsteProizvodaController(IVrsteProizvodaService service) : base(service)
        {
        }
        [Authorize(Roles = "Admin,Kupac")]
        public override PagedResult<VrsteProizvodaDTO> GetList([FromQuery] VrsteProizvodaSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Admin,Kupac")]
        public override VrsteProizvodaDTO GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Admin")]
        public override VrsteProizvodaDTO Insert(VrsteProizvodaUpsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override VrsteProizvodaDTO Update(int id, VrsteProizvodaUpsertRequest request)
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
