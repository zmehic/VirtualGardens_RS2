using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.DTOs.StatisticsDTOs;
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
        [HttpPut("{id}/inprogress")]
        public NarudzbeDTO InProgress(int id)
        {
            return (_service as INarudzbeService)!.InProgress(id);
        }

        [Authorize(Roles = "Kupac")]
        [HttpGet("CheckOrderValidity/{orderid}")]
        public List<string> CheckOrderValidity(int orderid)
        {
            return (_service as INarudzbeService)!.CheckOrderValidity(orderid);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}/edit")]
        public NarudzbeDTO Edit(int id)
        {
            return (_service as INarudzbeService)!.Edit(id);
        }

        [Authorize(Roles = "Kupac")]
        public override NarudzbeDTO Insert(NarudzbeUpsertRequest request)
        {
            return (_service as INarudzbeService)!.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}/finish")]
        public NarudzbeDTO Finish(int id)
        {
            return (_service as INarudzbeService)!.Finish(id);
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("{id}/allowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as INarudzbeService)!.AllowedActions(id);
        }

        [Authorize(Roles ="Admin")]
        [HttpGet("MonthlyStatistics")]
        public StatisticsDTO MonthlyStatistics(int year) {
            return (_service as INarudzbeService)!.MonthlyStatistics(year);
        }
    }
}
