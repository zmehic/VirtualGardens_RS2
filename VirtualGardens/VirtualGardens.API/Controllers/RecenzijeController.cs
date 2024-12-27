using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.HelperClasses;
using VirtualGardens.Models.Requests.Proizvodi;
using VirtualGardens.Models.Requests.Recenzije;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.Recenzije;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RecenzijeController : BaseCRUDController<Models.DTOs.RecenzijeDTO, RecenzijeSearchObject, RecenzijeUpsertRequest, RecenzijeUpsertRequest>
    {
        public RecenzijeController(IRecenzijeService service) : base(service)
        {
        }

    }
}
