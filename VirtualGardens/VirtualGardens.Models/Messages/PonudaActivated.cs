using EasyNetQ;
using System;
using System.Collections.Generic;
using System.Text;
using VirtualGardens.Models.DTOs;

namespace VirtualGardens.Models.Messages
{
    public class PonudaActivated
    {
        public string ime { get; set; }
        public string prezime { get; set; }
        public string email { get; set; }
        public string nazivPonude { get; set; }
        public int? popust { get; set; }
    }
}
