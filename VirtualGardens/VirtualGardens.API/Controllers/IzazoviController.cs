using Azure.Core;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Korisnici;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices;
using VirtualGardens.Services.BaseInterfaces;
using VirtualGardens.Services.Database;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class IzazoviController : BaseCRUDController<Models.DTOs.KorisnikIzazovDTO, IzazovSearchObject, IzazovUpsertRequest, IzazovUpsertRequest>
    {
        public IzazoviController(IUserIzazovService service) : base(service)
        {
        }

        [HttpGet("duplicate")]
        public bool CheckDuplicate([FromQuery]PeerIzazovUpsertRequest request)
        {
            return (_service as IUserIzazovService)!.CheckDuplicate(request);
        }
        [HttpGet("nagrada")]
        public ChallengeReward14072025? CheckNagrada([FromQuery] KorisnikIzazovDTO izazov)
        {
            return (_service as IUserIzazovService)!.CheckNagrada(izazov);
        }
        [HttpGet("statistika")]
        public List<StatistikaDTO> GetStatistika([FromQuery] IzazovSearchObject searchObject)
        {
            return (_service as IUserIzazovService)!.GetStatistika(searchObject);
        }
        [HttpGet("izazovi")]
        public List<IzazovDTO> GetIzazovi()
        {
            return (_service as IUserIzazovService)!.GetIzazovi();
        }

        [HttpGet("activate")]
        public bool Activate([FromQuery] int id)
        {
            return (_service as IUserIzazovService)!.Activate(id);
        }
        [HttpPost("peer")]
        public bool? InsertChallenge(PeerIzazovUpsertRequest request)
        {
            return (_service as IUserIzazovService)!.InsertChallenge(request);

        }
        [HttpPut("end")]
        public bool End([FromQuery]int peerIzazovId)
        {
            return (_service as IUserIzazovService)!.End(peerIzazovId);

        }

        [HttpPut("begin")]
        public bool Begin([FromQuery] int peerIzazovId)
        {
            return (_service as IUserIzazovService)!.Begin(peerIzazovId);

        }
    }
}
