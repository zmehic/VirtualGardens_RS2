using Microsoft.AspNetCore.Mvc;
using VirtualGardens.Services.Database;
using VirtualGardens.Services;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Models.Requests.Proizvodi;
using VirtualGardens.Services.BaseInterfaces;
using VirtualGardens.Models.DTOs;

namespace VirtualGardens.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProizvodiController : BaseCRUDController<Models.DTOs.ProizvodiDTO, ProizvodiSearchObject, ProizvodiUpsertRequest, ProizvodiUpsertRequest>
    {
        public ProizvodiController(IProizvodiService service) : base(service)
        {
        }
    }
}
