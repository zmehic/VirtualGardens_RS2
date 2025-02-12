using System;
using System.Collections.Generic;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.Database;

public partial class Narudzbe: ISoftDeletable
{
    public int NarudzbaId { get; set; }

    public string BrojNarudzbe { get; set; } = null!;

    public bool? Otkazana { get; set; } = false;

    public DateTime Datum { get; set; } = DateTime.Now;

    public bool Placeno { get; set; } = false;
    public string? StateMachine { get; set; }

    public bool? Status { get; set; }

    public float UkupnaCijena { get; set; }

    public int KorisnikId { get; set; }

    public int? NalogId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Nalozi? Nalog { get; set; }

    public virtual ICollection<PitanjaOdgovori> PitanjaOdgovoris { get; set; } = new List<PitanjaOdgovori>();

    public virtual ICollection<Setovi> Setovis { get; set; } = new List<Setovi>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
