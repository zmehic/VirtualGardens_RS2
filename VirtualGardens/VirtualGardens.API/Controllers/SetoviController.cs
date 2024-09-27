using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests.Setovi;
using VirtualGardens.Models.Requests.VrsteProizvoda;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.Setovi;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SetoviController : BaseCRUDController<Models.DTOs.SetoviDTO, SetoviSearchObject, SetoviUpsertRequest, SetoviUpsertRequest>
    {
        public SetoviController(ISetoviService service) : base(service)
        {
        }

        [Authorize(Roles = "Kupac,Admin")]
        public override SetoviDTO Insert(SetoviUpsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Kupac,Admin")]
        public override SetoviDTO Update(int id, SetoviUpsertRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Kupac,Admin")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }
    }
}
