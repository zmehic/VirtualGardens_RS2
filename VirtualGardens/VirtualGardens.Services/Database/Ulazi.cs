using System;
using System.Collections.Generic;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.Database;

public partial class Ulazi : ISoftDeletable
{
    public int UlazId { get; set; }

    public string BrojUlaza { get; set; } = null!;

    public DateTime DatumUlaza { get; set; } = DateTime.Now;

    public int KorisnikId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual ICollection<UlaziProizvodi> UlaziProizvodis { get; set; } = new List<UlaziProizvodi>();

    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
