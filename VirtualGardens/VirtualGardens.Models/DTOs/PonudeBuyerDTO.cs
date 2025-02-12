using EasyNetQ.Producer;
using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class PonudeBuyerDTO
    {
        public int PonudaId { get; set; }

        public string Naziv { get; set; } = null!;

        public int? Popust { get; set; }
        public string? StateMachine { get; set; }

        public DateTime DatumKreiranja { get; set; }

        public List<ProizvodiSetBuyer> ProizvodiSetovi { get; set; }
    }
}
