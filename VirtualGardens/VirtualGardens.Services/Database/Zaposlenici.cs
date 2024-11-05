using System;
using System.Collections.Generic;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.Database;

public partial class Zaposlenici : ISoftDeletable
{
    public int ZaposlenikId { get; set; }

    public string Email { get; set; } = null!;

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string? BrojTelefona { get; set; }

    public string? Adresa { get; set; }

    public string? Grad { get; set; }

    public string? Drzava { get; set; }

    public bool JeAktivan { get; set; } = true;

    public DateTime? DatumRodjenja { get; set; }

    public virtual ICollection<Nalozi> Nalozis { get; set; } = new List<Nalozi>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
