using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests.Proizvodi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.ProizvodiNoImage
{
    public interface IProizvodiNoImageService : IService<Models.DTOs.ProizvodiNoImageDTO, ProizvodiSearchObject>
    {
    }
}
