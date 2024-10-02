using System;
using System.Collections.Generic;
using System.Text;
using VirtualGardens.Models.DTOs;

namespace VirtualGardens.Models.Messages
{
    public class PonudaActivated
    {
        public KorisniciDTO korisnik { get; set; }
        public PonudeDTO ponuda { get; set; }
    }
}
