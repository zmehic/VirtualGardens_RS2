using VirtualGardens.Models;

namespace VirtualGardens.Services.Database
{
    public class UserChallenge14072024
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public virtual Korisnici Korisnik { get; set; }
        public int IzazovId { get; set; }
        public virtual Challenge14072025 Izazov { get; set; }
        public DateTime DatumPrihvatanja { get; set; }
        public Status Status { get; set; }
        public int BrojPonavljanja { get; set; }
        public DateTime? VrijemeZavrsetka { get; set; }
    }
}
