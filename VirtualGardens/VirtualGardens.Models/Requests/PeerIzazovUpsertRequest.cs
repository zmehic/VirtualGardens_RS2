using System;
using VirtualGardens.Models.DTOs;

namespace VirtualGardens.Models.Requests
{
    public class PeerIzazovUpsertRequest
    {
        public int KorisnikIzazivacId { get; set; }
        public int KorisnikIzazvaniId { get; set; }
        public int IzazovId { get; set; }
        public DateTime DatumKreiranja { get; set; } = DateTime.UtcNow;
        public PeerStatus Status { get; set; } = PeerStatus.Poslan;
        public string? Poruka { get; set; }
    }
}
