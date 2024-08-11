using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class KorisniciUloge
{
    public int KorisniciUlogeId { get; set; }

    public int KorisnikId { get; set; }

    public int UlogaId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Uloge Uloga { get; set; } = null!;
}
