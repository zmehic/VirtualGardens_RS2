using System;
using System.Collections.Generic;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.Database;

public partial class PitanjaOdgovori : ISoftDeletable
{
    public int PitanjeId { get; set; }

    public string Tekst { get; set; } = null!;

    public DateTime Datum { get; set; } = DateTime.Now;

    public int KorisnikId { get; set; }

    public int NarudzbaId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Narudzbe Narudzba { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
