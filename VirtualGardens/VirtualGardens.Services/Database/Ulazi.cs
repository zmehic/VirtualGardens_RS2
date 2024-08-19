using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class Ulazi
{
    public int UlazId { get; set; }

    public string BrojUlaza { get; set; } = null!;

    public DateTime DatumUlaza { get; set; } = DateTime.Now;

    public int KorisnikId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual ICollection<UlaziProizvodi> UlaziProizvodis { get; set; } = new List<UlaziProizvodi>();
}
