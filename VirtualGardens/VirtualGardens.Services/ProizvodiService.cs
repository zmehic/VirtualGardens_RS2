using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services
{
    public class ProizvodiService:IProizvodiService
    {
        public _210011Context Context { get; set; }
        public ProizvodiService(_210011Context context)
        {
            Context = context;
        }

        public virtual List<Proizvodi> GetList()
        {
            var list = Context.Proizvodis.ToList();
            return list;
        }
    }
}
