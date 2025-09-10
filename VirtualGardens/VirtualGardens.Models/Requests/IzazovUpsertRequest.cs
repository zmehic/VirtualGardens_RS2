using System;

namespace VirtualGardens.Models.Requests
{
    public class IzazovUpsertRequest
    {
        public int KorisnikId { get; set; }
        public int IzazovId { get; set; }
        public DateTime DatumPrihvatanja { get; set; }
        public Status Status { get; set; }
        public int BrojPonavljanja { get; set; } = 0;
        public DateTime? VrijemeZavrsetka { get; set; }
    }
}
