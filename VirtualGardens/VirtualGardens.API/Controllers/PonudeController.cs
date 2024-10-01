using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests.Ponude;
using VirtualGardens.Models.Requests.SetoviPonude;
using VirtualGardens.Models.Requests.VrsteProizvoda;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.Narudzbe;
using VirtualGardens.Services.AllServices.Ponude;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PonudeController : BaseCRUDController<PonudeDTO, PonudeSearchObject, PonudeUpsertRequest, PonudeUpsertRequest>
    {
        public PonudeController(IPonudeService service) : base(service)
        {
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}/activate")]
        public PonudeDTO Activate(int id)
        {
            return (_service as IPonudeService).Activate(id);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}/edit")]
        public PonudeDTO Edit(int id)
        {
            return (_service as IPonudeService).Edit(id);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}/finish")]
        public PonudeDTO Finish(int id)
        {
            return (_service as IPonudeService).Finish(id);
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("{id}/allowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as IPonudeService).AllowedActions(id);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost("{id}/addSet")]
        public PonudeDTO AddSet(SetoviPonudeUpsertRequest request)
        {
            return (_service as IPonudeService).AddSet(request);
        }
    }
}
