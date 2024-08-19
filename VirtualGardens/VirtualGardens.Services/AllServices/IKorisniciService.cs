using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices
{
    public interface IKorisniciService : ICRUDService<Models.DTOs.KorisniciDTO, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        Models.DTOs.KorisniciDTO Login(string username, string password);
    }
}
