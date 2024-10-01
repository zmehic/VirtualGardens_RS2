using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.Setovi
{
    public class SetoviUpsertRequest
    {
        public int Cijena { get; set; }

        public int? Popust { get; set; }

        public int? NarudzbaId { get; set; }

        public int? CijenaSaPopustom { get; set; }
    }
}
