using Microsoft.AspNetCore.Mvc;
using VirtualGardens.Services.Database;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Models.Requests.Proizvodi;
using VirtualGardens.Services.BaseInterfaces;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.HelperClasses;
using Microsoft.AspNetCore.Authorization;
using VirtualGardens.Services.AllServices;
using VirtualGardens.Services.AllServices.Proizvodi;

namespace VirtualGardens.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProizvodiController : BaseCRUDController<Models.DTOs.ProizvodiDTO, ProizvodiSearchObject, ProizvodiUpsertRequest, ProizvodiUpsertRequest>
    {
        public ProizvodiController(IProizvodiService service) : base(service)
        {
        }

        [Authorize(Roles = "Admin")]
        public override ProizvodiDTO Insert(ProizvodiUpsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override ProizvodiDTO Update(int id, ProizvodiUpsertRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Admin")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }


        [Authorize(Roles="Kupac")]
        [HttpGet("{id}/recommend")]
        public List<ProizvodiDTO> Recommend(int id)
        {
            return (_service as IProizvodiService)!.Recommend(id);
        }

        [HttpGet("trainmodel")]
        [Authorize(Roles ="Admin")]
        public void TrainModel()
        {
            (_service as IProizvodiService)!.TrainModel();
        }
    }
}
