using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Ponude;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.Ponude
{
    public interface IPonudeService : ICRUDService<Models.DTOs.PonudeDTO, PonudeSearchObject, PonudeUpsertRequest, PonudeUpsertRequest>
    {
    }
}
