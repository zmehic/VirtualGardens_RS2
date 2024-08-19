using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.SearchObjects
{
    public class UlaziProizvodiSearchObject : BaseSearchObject
    {
        public int? UlazId { get; set; }

        public int? ProizvodId { get; set; }

        public int? KolicinaFrom { get; set; }

        public int? KolicinaTo { get; set; }
    }
}
