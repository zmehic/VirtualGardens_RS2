using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services
{
    public interface IProizvodiService
    {
        List<Proizvodi> GetList();
    }
}
