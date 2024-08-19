using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.SearchObjects
{
    public class NaloziSearchObject : BaseSearchObject
    {
        public string? BrojNalogaGTE { get; set; }

        public DateTime? DatumKreiranjaFrom { get; set; }

        public DateTime? DatumKreiranjaTo { get; set; }

        public int? ZaposlenikId { get; set; }

        public bool? Zavrsen { get; set; }
    }
}
