using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class UlogeDTO
    {
        public int UlogaId { get; set; }

        public string Naziv { get; set; }

        //public virtual ICollection<GeneralDTO.KorisniciUlogeDTO> KorisniciUloges { get; set; } = new List<GeneralDTO.KorisniciUlogeDTO>();
    }
}
