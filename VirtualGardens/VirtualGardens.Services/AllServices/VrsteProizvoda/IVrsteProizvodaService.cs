using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests.VrsteProizvoda;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.VrsteProizvoda
{
    public interface IVrsteProizvodaService : ICRUDService<Models.DTOs.VrsteProizvodaDTO, VrsteProizvodaSearchObject, VrsteProizvodaUpsertRequest, VrsteProizvodaUpsertRequest>
    {
    }
}
