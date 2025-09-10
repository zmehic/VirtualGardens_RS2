using VirtualGardens.Models;

namespace VirtualGardens.Services.Database
{
    public class PeerChallenge14072025
    {
        public int Id { get; set; }
        public int KorisnikIzazivacId { get; set; }
        public virtual Korisnici KorisnikIzazivac { get; set; }
        public int KorisnikIzazvaniId { get; set; }
        public virtual Korisnici KorisnikIzazvani { get; set; }
        public int IzazovId { get; set; }
        public virtual Challenge14072025 Izazov { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public PeerStatus Status { get; set; }
        public string? Poruka { get; set; }
    }
}
