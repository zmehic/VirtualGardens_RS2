﻿using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class PitanjaOdgovori
{
    public int PitanjeId { get; set; }

    public string Tekst { get; set; } = null!;

    public DateTime Datum { get; set; }

    public int KorisnikId { get; set; }

    public int NarudzbaId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Narudzbe Narudzba { get; set; } = null!;
}
