using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.SearchObjects
{
    public class PitanjaOdgovoriSearchObject : BaseSearchObject
    {
        public DateTime? DatumFrom { get; set; }

        public DateTime? DatumTo { get; set; }

        public int? KorisnikId { get; set; }

        public int? NarudzbaId { get; set; }
    }
}
