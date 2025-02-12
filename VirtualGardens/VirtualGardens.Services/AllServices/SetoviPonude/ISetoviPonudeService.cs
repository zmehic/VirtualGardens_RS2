using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests.Recenzije;
using VirtualGardens.Models.Requests.SetoviPonude;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.SetoviPonude
{
    public interface ISetoviPonudeService : ICRUDService<Models.DTOs.SetoviPonudeDTO, SetoviPonudeSearchObject, SetoviPonudeUpsertRequest, SetoviPonudeUpsertRequest>
    {
    }
}
