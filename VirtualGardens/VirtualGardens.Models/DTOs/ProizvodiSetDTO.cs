using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class ProizvodiSetDTO
    {
        public int ProizvodSetId { get; set; }

        public int ProizvodId { get; set; }

        public int SetId { get; set; }

        public int Kolicina { get; set; }

        public virtual ProizvodiDTO Proizvod { get; set; } = null!;

        public virtual SetoviDTO Set { get; set; } = null!;
    }
}
