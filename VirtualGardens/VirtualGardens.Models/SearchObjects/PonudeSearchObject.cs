using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.SearchObjects
{
    public class PonudeSearchObject : BaseSearchObject
    {
        public string? NazivContains { get; set; }

        public int? PopustFrom { get; set; }

        public int? PopustTo { get; set; }

        public string? StateMachine { get; set; }
        public DateTime? DatumFrom { get; set; }

        public DateTime? DatumTo { get; set; }

    }
}
