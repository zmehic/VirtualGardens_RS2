using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RabbitMQ.Client;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.HelperClasses;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.JediniceMjere;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.JediniceMjere;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class JediniceMjereController : BaseCRUDController<Models.DTOs.JediniceMjereDTO, JediniceMjereSearchObject, JediniceMjereUpsertRequest, JediniceMjereUpsertRequest>
    {
        public JediniceMjereController(IJediniceMjereService service) : base(service)
        {
            
        }

        [Authorize(Roles = "Admin")]
        public override JediniceMjereDTO Insert(JediniceMjereUpsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override JediniceMjereDTO Update(int id, JediniceMjereUpsertRequest request)
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
