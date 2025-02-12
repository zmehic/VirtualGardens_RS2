using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Proizvodi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.Proizvodi
{
    public interface IProizvodiService : ICRUDService<ProizvodiDTO, ProizvodiSearchObject, ProizvodiUpsertRequest, ProizvodiUpsertRequest>
    {
        List<ProizvodiDTO> Recommend(int id);
        void TrainModel();
    }
}
