using System;
using System.Collections.Generic;
using System.Text;
using VirtualGardens.Models.SearchObjects;

namespace VirtualGardens.Models.DTOs
{
    public class ProizvodiSetSearchObject : BaseSearchObject
    {
        public int? ProizvodId { get; set; }

        public int? SetId { get; set; }

        public int? KolicinaFrom { get; set; }

        public int? KolicinaTo { get; set; }
    }

}
