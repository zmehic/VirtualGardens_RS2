using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class KorisniciUlogeDTO
    {
        public int KorisnikUlogeId { get; set; }

        public int KorisnikId { get; set; }
        public int UlogaId { get; set; }

        public virtual DTOs.UlogeDTO? Uloga { get; set; }

        //public DTOs.KorisniciDTO? Korisnik { get; set; }
    }
}
