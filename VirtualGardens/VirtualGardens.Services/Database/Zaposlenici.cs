using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class Zaposlenici
{
    public int ZaposlenikId { get; set; }

    public string Email { get; set; } = null!;

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string? BrojTelefona { get; set; }

    public string? Adresa { get; set; }

    public string? Grad { get; set; }

    public string? Drzava { get; set; }

    public bool JeAktivan { get; set; }

    public DateTime? DatumRodjenja { get; set; }

    public virtual ICollection<Nalozi> Nalozis { get; set; } = new List<Nalozi>();
}
