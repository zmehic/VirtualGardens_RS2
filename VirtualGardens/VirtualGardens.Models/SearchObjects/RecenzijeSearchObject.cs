using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.SearchObjects
{
    public class RecenzijeSearchObject : BaseSearchObject
    {
        public int? OcjenaFrom { get; set; }

        public int? OcjenaTo { get; set; }

        public int? KorisnikId { get; set; }

        public DateTime? DatumFrom { get; set; }

        public DateTime? DatumTo { get; set; }

        public int? ProizvodId { get; set; }
    }
}
