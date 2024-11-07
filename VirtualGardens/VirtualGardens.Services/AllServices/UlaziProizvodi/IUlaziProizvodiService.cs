using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.UlaziProizvodi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.UlaziProizvodi
{
    public interface IUlaziProizvodiService : ICRUDService<Models.DTOs.UlaziProizvodiDTO, UlaziProizvodiSearchObject, UlaziProizvodiUpsertRequest, UlaziProizvodiUpsertRequest>
    {

    }
}
