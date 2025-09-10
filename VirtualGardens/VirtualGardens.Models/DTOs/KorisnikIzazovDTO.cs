using System;

namespace VirtualGardens.Models.DTOs
{
    public class KorisnikIzazovDTO
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public virtual KorisniciDTO Korisnik { get; set; }
        public int IzazovId { get; set; }
        public virtual IzazovDTO Izazov { get; set; }
        public DateTime DatumPrihvatanja { get; set; }
        public Status Status { get; set; }
        public int BrojPonavljanja { get; set; }
        public DateTime? VrijemeZavrsetka { get; set; }
    }
}
