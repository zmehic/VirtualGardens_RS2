﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests.Ulazi;
using VirtualGardens.Models.Requests.UlaziProizvodi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.UlaziProizvodi;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UlaziProizvodiController : BaseCRUDController<Models.DTOs.UlaziProizvodiDTO, UlaziProizvodiSearchObject, UlaziProizvodiUpsertRequest, UlaziProizvodiUpsertRequest>
    {
        public UlaziProizvodiController(IUlaziProizvodiService service) : base(service)
        {
        }
    }
}
