using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.SearchObjects
{
    public class SetoviSearchObject : BaseSearchObject
    {
        public int? CijenaFrom { get; set; }

        public int? CijenaTo { get; set; }

        public int? PopustFrom { get; set; }

        public int? PopustTo { get; set; }

        public int? NarudzbaId { get; set; }

        public int? CijenaSaPopustomFrom { get; set; }

        public int? CijenaSaPopustomTo { get; set; }
    }
}
