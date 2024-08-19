using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.SearchObjects
{
    public class ZaposleniciSearchObject : BaseSearchObject
    {
        public string? ImeGTE { get; set; }

        public string? PrezimeGTE { get; set; }

        public string? BrojTelefona { get; set; }

        public string? Adresa { get; set; }

        public string? GradGTE { get; set; }

        public string? DrzavaGTE { get; set; }

        public bool? JeAktivan { get; set; }
    }
}
