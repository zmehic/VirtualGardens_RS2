using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class Narudzbe
{
    public int NarudzbaId { get; set; }

    public string BrojNarudzbe { get; set; } = null!;

    public bool? Otkazana { get; set; } = false;

    public DateTime Datum { get; set; } = DateTime.Now;

    public bool Placeno { get; set; } = false;

    public bool? Status { get; set; }

    public int UkupnaCijena { get; set; }

    public int KorisnikId { get; set; }

    public int? NalogId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Nalozi? Nalog { get; set; }

    public virtual ICollection<PitanjaOdgovori> PitanjaOdgovoris { get; set; } = new List<PitanjaOdgovori>();

    public virtual ICollection<Setovi> Setovis { get; set; } = new List<Setovi>();
}
