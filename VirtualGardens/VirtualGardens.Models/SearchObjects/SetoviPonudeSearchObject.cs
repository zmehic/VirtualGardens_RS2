using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.SearchObjects
{
    public class SetoviPonudeSearchObject : BaseSearchObject
    {
        public int? SetId { get; set; }

        public int? PonudaId { get; set; }
    }
}
