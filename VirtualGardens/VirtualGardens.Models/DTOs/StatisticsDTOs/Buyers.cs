using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs.StatisticsDTOs
{
    public class Buyers
    {
        public KorisniciDTO korisnik { get; set; }
        public int brojNarudzbi { get; set; } = 0;
    }
}
