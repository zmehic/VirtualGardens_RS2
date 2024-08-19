using System;
using System.Collections.Generic;
using System.Text;
using VirtualGardens.Models.DTOs;

namespace VirtualGardens.Models.SearchObjects
{
    public class UlaziSearchObject : BaseSearchObject
    {
        public string? BrojUlazaGTE { get; set; }

        public DateTime? DatumUlazaFrom { get; set; }

        public DateTime? DatumUlazaTo { get; set; }

        public int? KorisnikId { get; set; }
    }
}
