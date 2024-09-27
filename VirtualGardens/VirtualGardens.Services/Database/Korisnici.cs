using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class Korisnici
{
    public int KorisnikId { get; set; }

    public string KorisnickoIme { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string? BrojTelefona { get; set; }

    public string? Adresa { get; set; }

    public string? Grad { get; set; }

    public string? Drzava { get; set; }

    public string LozinkaHash { get; set; } = null!;

    public string LozinkaSalt { get; set; } = null!;

    public DateTime DatumRegistracije { get; set; }

    public DateTime? ZadnjiLogin { get; set; }

    public bool JeAktivan { get; set; } = true;

    public DateTime? DatumRodjenja { get; set; }

    public virtual ICollection<KorisniciUloge> KorisniciUloges { get; set; } = new List<KorisniciUloge>();

    public virtual ICollection<Narudzbe> Narudzbes { get; set; } = new List<Narudzbe>();

    public virtual ICollection<PitanjaOdgovori> PitanjaOdgovoris { get; set; } = new List<PitanjaOdgovori>();

    public virtual ICollection<Recenzije> Recenzijes { get; set; } = new List<Recenzije>();

    public virtual ICollection<Ulazi> Ulazis { get; set; } = new List<Ulazi>();
}
