using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.HelperClasses;
using VirtualGardens.Models.Requests.Proizvodi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.ProizvodiNoImage;

namespace VirtualGardens.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProizvodiNoImageController : BaseController<Models.DTOs.ProizvodiNoImageDTO, ProizvodiSearchObject>
    {
        public ProizvodiNoImageController(IProizvodiNoImageService service) : base(service)
        {
        }

        [Authorize(Roles = "Admin,Kupac")]
        public override PagedResult<ProizvodiNoImageDTO> GetList([FromQuery] ProizvodiSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Admin,Kupac")]
        public override ProizvodiNoImageDTO GetById(int id)
        {
            return base.GetById(id);
        }
    }
}
