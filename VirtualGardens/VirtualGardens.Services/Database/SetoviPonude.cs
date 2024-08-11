using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class SetoviPonude
{
    public int SetoviPonudeId { get; set; }

    public int SetId { get; set; }

    public int PonudaId { get; set; }

    public virtual Ponude Ponuda { get; set; } = null!;

    public virtual Setovi Set { get; set; } = null!;
}
