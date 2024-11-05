using System;
using System.Collections.Generic;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.Database;

public partial class Recenzije : ISoftDeletable
{
    public int RecenzijaId { get; set; }

    public int Ocjena { get; set; }

    public string? Komentar { get; set; }

    public int KorisnikId { get; set; }

    public DateTime Datum { get; set; } = DateTime.Now;

    public int ProizvodId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Proizvodi Proizvod { get; set; } = null!;

    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
