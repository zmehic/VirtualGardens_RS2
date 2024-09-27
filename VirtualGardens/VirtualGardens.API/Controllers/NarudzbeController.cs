using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.Narudzbe;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NarudzbeController : BaseCRUDController<Models.DTOs.NarudzbeDTO, NarudzbeSearchObject, NarudzbeUpsertRequest, NarudzbeUpsertRequest>
    {
        public NarudzbeController(INarudzbeService service) : base(service)
        {
        }

        [Authorize(Roles = "Admin,Kupac")]
        public override NarudzbeDTO Update(int id, NarudzbeUpsertRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Admin,Kupac")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }

        [Authorize(Roles = "Admin,Kupac")]
        public override NarudzbeDTO Insert(NarudzbeUpsertRequest request)
        {
            return base.Insert(request);
        }

        [HttpPut("{id}/inprogress")]
        public NarudzbeDTO InProgress(int id)
        {
            return (_service as INarudzbeService).InProgress(id);
        }

        [HttpPut("{id}/edit")]
        public NarudzbeDTO Edit(int id)
        {
            return (_service as INarudzbeService).Edit(id);
        }

        [HttpPut("{id}/finish")]
        public NarudzbeDTO Finish(int id)
        {
            return (_service as INarudzbeService).Finish(id);
        }

        [HttpGet("{id}/allowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as INarudzbeService).AllowedActions(id);
        }
    }
}
