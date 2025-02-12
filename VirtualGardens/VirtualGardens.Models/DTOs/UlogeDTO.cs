using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class UlogeDTO
    {
        public int UlogaId { get; set; }

        public string Naziv { get; set; }
        public string? Opis { get; set; }

        //public virtual ICollection<KorisniciUlogeDTO> KorisniciUloges { get; set; } = new List<KorisniciUlogeDTO>();
    }
}
