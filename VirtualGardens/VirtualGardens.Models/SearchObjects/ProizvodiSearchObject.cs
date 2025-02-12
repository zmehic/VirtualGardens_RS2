using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.SearchObjects
{
    public class ProizvodiSearchObject : BaseSearchObject
    {
        public string? NazivGTE { get; set; }

        public float? CijenaFrom { get; set; }

        public float? CijenaTo { get; set; }

        public int? DostupnaKolicinaFrom { get; set; }

        public int? DostupnaKolicinaTo { get; set; }

        public int? JedinicaMjereId { get; set; }

        public int? VrstaProizvodaId { get; set; }
    }
}
