using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class Recenzije
{
    public int RecenzijaId { get; set; }

    public int Ocjena { get; set; }

    public string? Komentar { get; set; }

    public int KorisnikId { get; set; }

    public DateTime Datum { get; set; }

    public int ProizvodId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Proizvodi Proizvod { get; set; } = null!;
}
