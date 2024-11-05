using System;
using System.Collections.Generic;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.Database;

public partial class KorisniciUloge : ISoftDeletable
{
    public int KorisniciUlogeId { get; set; }

    public int KorisnikId { get; set; }

    public int UlogaId { get; set; }

    public virtual Korisnici? Korisnik { get; set; }

    public virtual Uloge? Uloga { get; set; }
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
