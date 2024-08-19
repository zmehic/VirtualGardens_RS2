using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.SearchObjects
{
    public class KorisniciUlogeSearchObject : BaseSearchObject
    {
        public int? UlogaId { get; set; }

        public int? KorisnikId { get; set; }
    }
}
