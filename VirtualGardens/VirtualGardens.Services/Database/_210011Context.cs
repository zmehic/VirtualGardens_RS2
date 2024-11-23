using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace VirtualGardens.Services.Database;

public partial class _210011Context : DbContext
{
    public _210011Context()
    {
    }

    public _210011Context(DbContextOptions<_210011Context> options)
        : base(options)
    {
    }

    public virtual DbSet<JediniceMjere> JediniceMjeres { get; set; }

    public virtual DbSet<Korisnici> Korisnicis { get; set; }

    public virtual DbSet<KorisniciUloge> KorisniciUloges { get; set; }

    public virtual DbSet<Nalozi> Nalozis { get; set; }

    public virtual DbSet<Narudzbe> Narudzbes { get; set; }

    public virtual DbSet<PitanjaOdgovori> PitanjaOdgovoris { get; set; }

    public virtual DbSet<Ponude> Ponudes { get; set; }

    public virtual DbSet<Proizvodi> Proizvodis { get; set; }

    public virtual DbSet<ProizvodiSet> ProizvodiSets { get; set; }

    public virtual DbSet<Recenzije> Recenzijes { get; set; }

    public virtual DbSet<Setovi> Setovis { get; set; }

    public virtual DbSet<SetoviPonude> SetoviPonudes { get; set; }

    public virtual DbSet<Ulazi> Ulazis { get; set; }

    public virtual DbSet<UlaziProizvodi> UlaziProizvodis { get; set; }

    public virtual DbSet<Uloge> Uloges { get; set; }

    public virtual DbSet<VrsteProizvodum> VrsteProizvoda { get; set; }

    public virtual DbSet<Zaposlenici> Zaposlenicis { get; set; }

//    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
//        => optionsBuilder.UseSqlServer("Data Source=localhost, 1433; Initial Catalog=210011;Trusted_Connection=True;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<JediniceMjere>(entity =>
        {
            entity.HasKey(e => e.JedinicaMjereId).HasName("PK__Jedinice__F73C302EAE0341E8");

            entity.ToTable("JediniceMjere");

            entity.Property(e => e.JedinicaMjereId).HasColumnName("JedinicaMjereID");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Opis)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.Skracenica)
                .HasMaxLength(10)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Korisnici>(entity =>
        {
            entity.HasKey(e => e.KorisnikId).HasName("PK__Korisnic__80B06D616063B1B0");

            entity.ToTable("Korisnici");

            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Adresa)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.BrojTelefona)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.DatumRegistracije).HasColumnType("datetime");
            entity.Property(e => e.DatumRodjenja).HasColumnType("datetime");
            entity.Property(e => e.Drzava)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Grad)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Ime)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.KorisnickoIme)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Prezime)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.ZadnjiLogin).HasColumnType("datetime");
        });

        modelBuilder.Entity<KorisniciUloge>(entity =>
        {
            entity.HasKey(e => e.KorisniciUlogeId).HasName("PK__Korisnic__DF71A2B5F416D0BC");

            entity.ToTable("Korisnici_Uloge");

            entity.Property(e => e.KorisniciUlogeId).HasColumnName("KorisniciUlogeID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.KorisniciUloges)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKorisnici_294617");

            entity.HasOne(d => d.Uloga).WithMany(p => p.KorisniciUloges)
                .HasForeignKey(d => d.UlogaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKorisnici_243985");
        });

        modelBuilder.Entity<Nalozi>(entity =>
        {
            entity.HasKey(e => e.NalogId).HasName("PK__Nalozi__D88333170E63FFCE");

            entity.ToTable("Nalozi");

            entity.Property(e => e.NalogId).HasColumnName("NalogID");
            entity.Property(e => e.BrojNaloga)
                .HasMaxLength(30)
                .IsUnicode(false);
            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.ZaposlenikId).HasColumnName("ZaposlenikID");

            entity.HasOne(d => d.Zaposlenik).WithMany(p => p.Nalozis)
                .HasForeignKey(d => d.ZaposlenikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKNalozi492203");
        });

        modelBuilder.Entity<Narudzbe>(entity =>
        {
            entity.HasKey(e => e.NarudzbaId).HasName("PK__Narudzbe__FBEC135729E59599");

            entity.ToTable("Narudzbe");

            entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");
            entity.Property(e => e.BrojNarudzbe)
                .HasMaxLength(30)
                .IsUnicode(false);
            entity.Property(e => e.Datum).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.NalogId).HasColumnName("NalogID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Narudzbes)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKNarudzbe980753");

            entity.HasOne(d => d.Nalog).WithMany(p => p.Narudzbes)
                .HasForeignKey(d => d.NalogId)
                .HasConstraintName("FKNarudzbe309039");
        });

        modelBuilder.Entity<PitanjaOdgovori>(entity =>
        {
            entity.HasKey(e => e.PitanjeId).HasName("PK__PitanjaO__1B924A4E327D27D3");

            entity.ToTable("PitanjaOdgovori");

            entity.Property(e => e.PitanjeId).HasColumnName("PitanjeID");
            entity.Property(e => e.Datum).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");
            entity.Property(e => e.Tekst)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.PitanjaOdgovoris)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKPitanjaOdg350158");

            entity.HasOne(d => d.Narudzba).WithMany(p => p.PitanjaOdgovoris)
                .HasForeignKey(d => d.NarudzbaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKPitanjaOdg958792");
        });

        modelBuilder.Entity<Ponude>(entity =>
        {
            entity.HasKey(e => e.PonudaId).HasName("PK__Ponude__5AF121B118A3B521");

            entity.ToTable("Ponude");

            entity.Property(e => e.PonudaId).HasColumnName("PonudaID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Proizvodi>(entity =>
        {
            entity.HasKey(e => e.ProizvodId).HasName("PK__Proizvod__21A8BE18421D72EE");

            entity.ToTable("Proizvodi");

            entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");
            entity.Property(e => e.JedinicaMjereId).HasColumnName("JedinicaMjereID");
            entity.Property(e => e.Naziv)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Opis)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.Slika).HasColumnType("image");
            entity.Property(e => e.SlikaThumb).HasColumnType("image");
            entity.Property(e => e.VrstaProizvodaId).HasColumnName("VrstaProizvodaID");

            entity.HasOne(d => d.JedinicaMjere).WithMany(p => p.Proizvodis)
                .HasForeignKey(d => d.JedinicaMjereId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKProizvodi730772").IsRequired();

            entity.Navigation(d => d.JedinicaMjere).AutoInclude();

            entity.HasOne(d => d.VrstaProizvoda).WithMany(p => p.Proizvodis)
                .HasForeignKey(d => d.VrstaProizvodaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKProizvodi787764");
        });

        modelBuilder.Entity<ProizvodiSet>(entity =>
        {
            entity.HasKey(e => e.ProizvodSetId).HasName("PK__Proizvod__6D2CD73590593B6D");

            entity.ToTable("Proizvodi_Set");

            entity.Property(e => e.ProizvodSetId).HasColumnName("ProizvodSetID");
            entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");
            entity.Property(e => e.SetId).HasColumnName("SetID");

            entity.HasOne(d => d.Proizvod).WithMany(p => p.ProizvodiSets)
                .HasForeignKey(d => d.ProizvodId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKProizvodi_145528").IsRequired();

            entity.Navigation(d => d.Proizvod).AutoInclude();

            entity.HasOne(d => d.Set).WithMany(p => p.ProizvodiSets)
                .HasForeignKey(d => d.SetId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKProizvodi_86253").IsRequired();

            entity.Navigation(d => d.Proizvod).AutoInclude();
        });

        modelBuilder.Entity<Recenzije>(entity =>
        {
            entity.HasKey(e => e.RecenzijaId).HasName("PK__Recenzij__D36C60906457BAC9");

            entity.ToTable("Recenzije");

            entity.Property(e => e.RecenzijaId).HasColumnName("RecenzijaID");
            entity.Property(e => e.Datum).HasColumnType("datetime");
            entity.Property(e => e.Komentar)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Recenzijes)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRecenzije432988");

            entity.HasOne(d => d.Proizvod).WithMany(p => p.Recenzijes)
                .HasForeignKey(d => d.ProizvodId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRecenzije100098");
        });

        modelBuilder.Entity<Setovi>(entity =>
        {
            entity.HasKey(e => e.SetId).HasName("PK__Setovi__7E08473D8E2A49C7");

            entity.ToTable("Setovi");

            entity.Property(e => e.SetId).HasColumnName("SetID");
            entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");

            entity.HasOne(d => d.Narudzba).WithMany(p => p.Setovis)
                .HasForeignKey(d => d.NarudzbaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKSetovi958895");

            entity.Navigation(d => d.ProizvodiSets).AutoInclude();
        });

        modelBuilder.Entity<SetoviPonude>(entity =>
        {
            entity.HasKey(e => e.SetoviPonudeId).HasName("PK__Setovi_P__5012E573A4D76D91");

            entity.ToTable("Setovi_Ponude");

            entity.Property(e => e.SetoviPonudeId).HasColumnName("SetoviPonudeID");
            entity.Property(e => e.PonudaId).HasColumnName("PonudaID");
            entity.Property(e => e.SetId).HasColumnName("SetID");

            entity.HasOne(d => d.Ponuda).WithMany(p => p.SetoviPonudes)
                .HasForeignKey(d => d.PonudaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKSetovi_Pon246820");

            entity.HasOne(d => d.Set).WithMany(p => p.SetoviPonudes)
                .HasForeignKey(d => d.SetId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKSetovi_Pon672336");
        });

        modelBuilder.Entity<Ulazi>(entity =>
        {
            entity.HasKey(e => e.UlazId).HasName("PK__Ulazi__732B78ADFE3085BD");

            entity.ToTable("Ulazi");

            entity.Property(e => e.UlazId).HasColumnName("UlazID");
            entity.Property(e => e.BrojUlaza)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.DatumUlaza).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Ulazis)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKUlazi845857");
        });

        modelBuilder.Entity<UlaziProizvodi>(entity =>
        {
            entity.HasKey(e => e.UlaziProizvodiId).HasName("PK__Ulazi_Pr__8587175320E977CB");

            entity.ToTable("Ulazi_Proizvodi");

            entity.Property(e => e.UlaziProizvodiId).HasColumnName("UlaziProizvodiID");
            entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");
            entity.Property(e => e.UlazId).HasColumnName("UlazID");

            entity.HasOne(d => d.Proizvod).WithMany(p => p.UlaziProizvodis)
                .HasForeignKey(d => d.ProizvodId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKUlazi_Proi921157");

            entity.HasOne(d => d.Ulaz).WithMany(p => p.UlaziProizvodis)
                .HasForeignKey(d => d.UlazId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKUlazi_Proi550210");
        });

        modelBuilder.Entity<Uloge>(entity =>
        {
            entity.HasKey(e => e.UlogaId).HasName("PK__Uloge__DCAB23EB052AF80A");

            entity.ToTable("Uloge");

            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");
            entity.Property(e => e.Naziv)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.Opis)
                .HasMaxLength(255)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VrsteProizvodum>(entity =>
        {
            entity.HasKey(e => e.VrstaProizvodaId).HasName("PK__VrstePro__7DC005C03E2A134E");

            entity.Property(e => e.VrstaProizvodaId).HasColumnName("VrstaProizvodaID");
            entity.Property(e => e.Naziv)
                .HasMaxLength(255)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Zaposlenici>(entity =>
        {
            entity.HasKey(e => e.ZaposlenikId).HasName("PK__Zaposlen__3F8CBE150E93A386");

            entity.ToTable("Zaposlenici");

            entity.Property(e => e.ZaposlenikId).HasColumnName("ZaposlenikID");
            entity.Property(e => e.Adresa)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.BrojTelefona)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.DatumRodjenja).HasColumnType("datetime");
            entity.Property(e => e.Drzava)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Grad)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Ime)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Prezime)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
