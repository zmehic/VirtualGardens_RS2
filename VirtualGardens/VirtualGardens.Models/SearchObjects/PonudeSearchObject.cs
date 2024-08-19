using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.SearchObjects
{
    public class PonudeSearchObject : BaseSearchObject
    {
        public string? NazivContains { get; set; } // For partial text search

        public int? PopustFrom { get; set; }

        public int? PopustTo { get; set; }

    }
}
