﻿using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VirtualGardens.API.Controllers.BaseControllers;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.HelperClasses;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices;

namespace VirtualGardens.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KorisniciController : BaseCRUDController<Models.DTOs.KorisniciDTO, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        public KorisniciController(IKorisniciService service) : base(service)
        {
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public Models.DTOs.KorisniciDTO Login(string username, string password)
        {
            return (_service as IKorisniciService).Login(username, password);
        }

        [AllowAnonymous]
        public override KorisniciDTO Insert(KorisniciInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Admin,Kupac")]
        public override KorisniciDTO GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Admin,Kupac")]
        public override KorisniciDTO Update(int id, KorisniciUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Admin")]
        public override PagedResult<KorisniciDTO> GetList([FromQuery] KorisniciSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
    }
}
