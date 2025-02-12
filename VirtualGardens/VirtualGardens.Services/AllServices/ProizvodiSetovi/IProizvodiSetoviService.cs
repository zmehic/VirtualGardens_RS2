using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.ProizvodiSetovi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.ProizvodiSetovi
{
    public interface IProizvodiSetoviService : ICRUDService<Models.DTOs.ProizvodiSetDTO, ProizvodiSetSearchObject, ProizvodiSetoviUpsertRequest, ProizvodiSetoviUpsertRequest>
    {
    }
}
