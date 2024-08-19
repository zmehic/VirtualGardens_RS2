using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Recenzije;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.Recenzije
{
    public interface IRecenzijeService : ICRUDService<Models.DTOs.RecenzijeDTO, RecenzijeSearchObject, RecenzijeUpsertRequest, RecenzijeUpsertRequest>
    {
    }
}
