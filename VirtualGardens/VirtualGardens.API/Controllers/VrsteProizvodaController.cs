using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
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
    }
}
