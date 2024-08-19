using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Proizvodi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services
{
    public interface IProizvodiService : ICRUDService<Models.DTOs.ProizvodiDTO, ProizvodiSearchObject, ProizvodiUpsertRequest, ProizvodiUpsertRequest>
    {

    }
}
