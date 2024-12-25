using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class ProizvodiSetBuyer
    {
        public int ProizvodSetId { get; set; }

        public int ProizvodId { get; set; }

        public int SetId { get; set; }
        public string NazivProizvoda { get; set; }

    }
}
