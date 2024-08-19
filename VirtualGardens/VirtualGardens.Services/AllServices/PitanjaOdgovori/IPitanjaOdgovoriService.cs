using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.PitanjaOdgovori;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.PitanjaOdgovori
{
    public interface IPitanjaOdgovoriService : ICRUDService<Models.DTOs.PitanjaOdgovoriDTO, PitanjaOdgovoriSearchObject, PitanjaOdgovoriUpsertRequest, PitanjaOdgovoriUpsertRequest>
    {
    }
}
