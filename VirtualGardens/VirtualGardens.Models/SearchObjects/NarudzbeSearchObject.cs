using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.SearchObjects
{
    public class NarudzbeSearchObject : BaseSearchObject
    {
        public string? BrojNarudzbeGTE { get; set; }

        public bool? Otkazana { get; set; }

        public DateTime? DatumFrom { get; set; }

        public DateTime? DatumTo { get; set; }

        public bool? Placeno { get; set; }

        public bool? Status { get; set; }

        public int? UkupnaCijenaFrom { get; set; }

        public int? UkupnaCijenaTo { get; set; }

        public int? KorisnikId { get; set; }

        public int? NalogId { get; set; }
    }
}
