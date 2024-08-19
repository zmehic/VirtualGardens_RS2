using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class SetoviPonudeDTO
    {
        public int SetoviPonudeId { get; set; }

        public int SetId { get; set; }

        public int PonudaId { get; set; }

        public virtual PonudeDTO Ponuda { get; set; } = null!;

        public virtual SetoviDTO Set { get; set; } = null!;
    }
}
