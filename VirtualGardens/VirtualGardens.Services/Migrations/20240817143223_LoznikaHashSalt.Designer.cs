﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using VirtualGardens.Services.Database;

#nullable disable

namespace VirtualGardens.Services.Migrations
{
    [DbContext(typeof(_210011Context))]
    [Migration("20240817143223_LoznikaHashSalt")]
    partial class LoznikaHashSalt
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "8.0.8")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("VirtualGardens.Services.Database.JediniceMjere", b =>
                {
                    b.Property<int>("JedinicaMjereId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("JedinicaMjereID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("JedinicaMjereId"));

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)");

                    b.Property<string>("Opis")
                        .HasMaxLength(255)
                        .IsUnicode(false)
                        .HasColumnType("varchar(255)");

                    b.Property<string>("Skracenica")
                        .HasMaxLength(10)
                        .IsUnicode(false)
                        .HasColumnType("varchar(10)");

                    b.HasKey("JedinicaMjereId")
                        .HasName("PK__Jedinice__F73C302EAE0341E8");

                    b.ToTable("JediniceMjere", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Korisnici", b =>
                {
                    b.Property<int>("KorisnikId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("KorisnikID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("KorisnikId"));

                    b.Property<string>("Adresa")
                        .HasMaxLength(255)
                        .IsUnicode(false)
                        .HasColumnType("varchar(255)");

                    b.Property<string>("BrojTelefona")
                        .HasMaxLength(20)
                        .IsUnicode(false)
                        .HasColumnType("varchar(20)");

                    b.Property<DateTime>("DatumRegistracije")
                        .HasColumnType("datetime");

                    b.Property<DateTime?>("DatumRodjenja")
                        .HasColumnType("datetime");

                    b.Property<string>("Drzava")
                        .HasMaxLength(100)
                        .IsUnicode(false)
                        .HasColumnType("varchar(100)");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasMaxLength(100)
                        .IsUnicode(false)
                        .HasColumnType("varchar(100)");

                    b.Property<string>("Grad")
                        .HasMaxLength(100)
                        .IsUnicode(false)
                        .HasColumnType("varchar(100)");

                    b.Property<string>("Ime")
                        .IsRequired()
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)");

                    b.Property<bool>("JeAktivan")
                        .HasColumnType("bit");

                    b.Property<string>("KorisnickoIme")
                        .IsRequired()
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)");

                    b.Property<string>("Lozinka")
                        .IsRequired()
                        .HasMaxLength(128)
                        .IsUnicode(false)
                        .HasColumnType("varchar(128)");

                    b.Property<string>("LozinkaHash")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("LozinkaSalt")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Prezime")
                        .IsRequired()
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)");

                    b.Property<DateTime?>("ZadnjiLogin")
                        .HasColumnType("datetime");

                    b.HasKey("KorisnikId")
                        .HasName("PK__Korisnic__80B06D616063B1B0");

                    b.ToTable("Korisnici", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.KorisniciUloge", b =>
                {
                    b.Property<int>("KorisniciUlogeId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("KorisniciUlogeID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("KorisniciUlogeId"));

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int")
                        .HasColumnName("KorisnikID");

                    b.Property<int>("UlogaId")
                        .HasColumnType("int")
                        .HasColumnName("UlogaID");

                    b.HasKey("KorisniciUlogeId")
                        .HasName("PK__Korisnic__DF71A2B5F416D0BC");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("UlogaId");

                    b.ToTable("Korisnici_Uloge", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Nalozi", b =>
                {
                    b.Property<int>("NalogId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("NalogID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("NalogId"));

                    b.Property<string>("BrojNaloga")
                        .IsRequired()
                        .HasMaxLength(30)
                        .IsUnicode(false)
                        .HasColumnType("varchar(30)");

                    b.Property<DateTime>("DatumKreiranja")
                        .HasColumnType("datetime");

                    b.Property<int>("ZaposlenikId")
                        .HasColumnType("int")
                        .HasColumnName("ZaposlenikID");

                    b.Property<bool>("Zavrsen")
                        .HasColumnType("bit");

                    b.HasKey("NalogId")
                        .HasName("PK__Nalozi__D88333170E63FFCE");

                    b.HasIndex("ZaposlenikId");

                    b.ToTable("Nalozi", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Narudzbe", b =>
                {
                    b.Property<int>("NarudzbaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("NarudzbaID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("NarudzbaId"));

                    b.Property<string>("BrojNarudzbe")
                        .IsRequired()
                        .HasMaxLength(30)
                        .IsUnicode(false)
                        .HasColumnType("varchar(30)");

                    b.Property<DateTime>("Datum")
                        .HasColumnType("datetime");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int")
                        .HasColumnName("KorisnikID");

                    b.Property<int?>("NalogId")
                        .HasColumnType("int")
                        .HasColumnName("NalogID");

                    b.Property<bool?>("Otkazana")
                        .HasColumnType("bit");

                    b.Property<bool>("Placeno")
                        .HasColumnType("bit");

                    b.Property<bool?>("Status")
                        .HasColumnType("bit");

                    b.Property<int>("UkupnaCijena")
                        .HasColumnType("int");

                    b.HasKey("NarudzbaId")
                        .HasName("PK__Narudzbe__FBEC135729E59599");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("NalogId");

                    b.ToTable("Narudzbe", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.PitanjaOdgovori", b =>
                {
                    b.Property<int>("PitanjeId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("PitanjeID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("PitanjeId"));

                    b.Property<DateTime>("Datum")
                        .HasColumnType("datetime");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int")
                        .HasColumnName("KorisnikID");

                    b.Property<int>("NarudzbaId")
                        .HasColumnType("int")
                        .HasColumnName("NarudzbaID");

                    b.Property<string>("Tekst")
                        .IsRequired()
                        .HasMaxLength(255)
                        .IsUnicode(false)
                        .HasColumnType("varchar(255)");

                    b.HasKey("PitanjeId")
                        .HasName("PK__PitanjaO__1B924A4E327D27D3");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("NarudzbaId");

                    b.ToTable("PitanjaOdgovori", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Ponude", b =>
                {
                    b.Property<int>("PonudaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("PonudaID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("PonudaId"));

                    b.Property<DateTime>("DatumKreiranja")
                        .HasColumnType("datetime");

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)");

                    b.Property<int?>("Popust")
                        .HasColumnType("int");

                    b.HasKey("PonudaId")
                        .HasName("PK__Ponude__5AF121B118A3B521");

                    b.ToTable("Ponude", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Proizvodi", b =>
                {
                    b.Property<int>("ProizvodId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ProizvodID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("ProizvodId"));

                    b.Property<float>("Cijena")
                        .HasColumnType("real");

                    b.Property<int>("DostupnaKolicina")
                        .HasColumnType("int");

                    b.Property<int>("JedinicaMjereId")
                        .HasColumnType("int")
                        .HasColumnName("JedinicaMjereID");

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasMaxLength(100)
                        .IsUnicode(false)
                        .HasColumnType("varchar(100)");

                    b.Property<string>("Opis")
                        .HasMaxLength(255)
                        .IsUnicode(false)
                        .HasColumnType("varchar(255)");

                    b.Property<byte[]>("Slika")
                        .HasColumnType("image");

                    b.Property<byte[]>("SlikaThumb")
                        .HasColumnType("image");

                    b.Property<int>("VrstaProizvodaId")
                        .HasColumnType("int")
                        .HasColumnName("VrstaProizvodaID");

                    b.HasKey("ProizvodId")
                        .HasName("PK__Proizvod__21A8BE18421D72EE");

                    b.HasIndex("JedinicaMjereId");

                    b.HasIndex("VrstaProizvodaId");

                    b.ToTable("Proizvodi", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.ProizvodiSet", b =>
                {
                    b.Property<int>("ProizvodSetId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ProizvodSetID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("ProizvodSetId"));

                    b.Property<int>("Kolicina")
                        .HasColumnType("int");

                    b.Property<int>("ProizvodId")
                        .HasColumnType("int")
                        .HasColumnName("ProizvodID");

                    b.Property<int>("SetId")
                        .HasColumnType("int")
                        .HasColumnName("SetID");

                    b.HasKey("ProizvodSetId")
                        .HasName("PK__Proizvod__6D2CD73590593B6D");

                    b.HasIndex("ProizvodId");

                    b.HasIndex("SetId");

                    b.ToTable("Proizvodi_Set", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Recenzije", b =>
                {
                    b.Property<int>("RecenzijaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("RecenzijaID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("RecenzijaId"));

                    b.Property<DateTime>("Datum")
                        .HasColumnType("datetime");

                    b.Property<string>("Komentar")
                        .HasMaxLength(255)
                        .IsUnicode(false)
                        .HasColumnType("varchar(255)");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int")
                        .HasColumnName("KorisnikID");

                    b.Property<int>("Ocjena")
                        .HasColumnType("int");

                    b.Property<int>("ProizvodId")
                        .HasColumnType("int")
                        .HasColumnName("ProizvodID");

                    b.HasKey("RecenzijaId")
                        .HasName("PK__Recenzij__D36C60906457BAC9");

                    b.HasIndex("KorisnikId");

                    b.HasIndex("ProizvodId");

                    b.ToTable("Recenzije", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Setovi", b =>
                {
                    b.Property<int>("SetId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("SetID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("SetId"));

                    b.Property<int>("Cijena")
                        .HasColumnType("int");

                    b.Property<int?>("CijenaSaPopustom")
                        .HasColumnType("int");

                    b.Property<int>("NarudzbaId")
                        .HasColumnType("int")
                        .HasColumnName("NarudzbaID");

                    b.Property<int?>("Popust")
                        .HasColumnType("int");

                    b.HasKey("SetId")
                        .HasName("PK__Setovi__7E08473D8E2A49C7");

                    b.HasIndex("NarudzbaId");

                    b.ToTable("Setovi", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.SetoviPonude", b =>
                {
                    b.Property<int>("SetoviPonudeId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("SetoviPonudeID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("SetoviPonudeId"));

                    b.Property<int>("PonudaId")
                        .HasColumnType("int")
                        .HasColumnName("PonudaID");

                    b.Property<int>("SetId")
                        .HasColumnType("int")
                        .HasColumnName("SetID");

                    b.HasKey("SetoviPonudeId")
                        .HasName("PK__Setovi_P__5012E573A4D76D91");

                    b.HasIndex("PonudaId");

                    b.HasIndex("SetId");

                    b.ToTable("Setovi_Ponude", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Ulazi", b =>
                {
                    b.Property<int>("UlazId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("UlazID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UlazId"));

                    b.Property<string>("BrojUlaza")
                        .IsRequired()
                        .HasMaxLength(20)
                        .IsUnicode(false)
                        .HasColumnType("varchar(20)");

                    b.Property<DateTime>("DatumUlaza")
                        .HasColumnType("datetime");

                    b.Property<int>("KorisnikId")
                        .HasColumnType("int")
                        .HasColumnName("KorisnikID");

                    b.HasKey("UlazId")
                        .HasName("PK__Ulazi__732B78ADFE3085BD");

                    b.HasIndex("KorisnikId");

                    b.ToTable("Ulazi", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.UlaziProizvodi", b =>
                {
                    b.Property<int>("UlaziProizvodiId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("UlaziProizvodiID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UlaziProizvodiId"));

                    b.Property<int>("Kolicina")
                        .HasColumnType("int");

                    b.Property<int>("ProizvodId")
                        .HasColumnType("int")
                        .HasColumnName("ProizvodID");

                    b.Property<int>("UlazId")
                        .HasColumnType("int")
                        .HasColumnName("UlazID");

                    b.HasKey("UlaziProizvodiId")
                        .HasName("PK__Ulazi_Pr__8587175320E977CB");

                    b.HasIndex("ProizvodId");

                    b.HasIndex("UlazId");

                    b.ToTable("Ulazi_Proizvodi", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Uloge", b =>
                {
                    b.Property<int>("UlogaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("UlogaID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UlogaId"));

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasMaxLength(255)
                        .IsUnicode(false)
                        .HasColumnType("varchar(255)");

                    b.Property<string>("Opis")
                        .HasMaxLength(255)
                        .IsUnicode(false)
                        .HasColumnType("varchar(255)");

                    b.HasKey("UlogaId")
                        .HasName("PK__Uloge__DCAB23EB052AF80A");

                    b.ToTable("Uloge", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.VrsteProizvodum", b =>
                {
                    b.Property<int>("VrstaProizvodaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("VrstaProizvodaID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("VrstaProizvodaId"));

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasMaxLength(255)
                        .IsUnicode(false)
                        .HasColumnType("varchar(255)");

                    b.HasKey("VrstaProizvodaId")
                        .HasName("PK__VrstePro__7DC005C03E2A134E");

                    b.ToTable("VrsteProizvoda");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Zaposlenici", b =>
                {
                    b.Property<int>("ZaposlenikId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasColumnName("ZaposlenikID");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("ZaposlenikId"));

                    b.Property<string>("Adresa")
                        .HasMaxLength(255)
                        .IsUnicode(false)
                        .HasColumnType("varchar(255)");

                    b.Property<string>("BrojTelefona")
                        .HasMaxLength(20)
                        .IsUnicode(false)
                        .HasColumnType("varchar(20)");

                    b.Property<DateTime?>("DatumRodjenja")
                        .HasColumnType("datetime");

                    b.Property<string>("Drzava")
                        .HasMaxLength(100)
                        .IsUnicode(false)
                        .HasColumnType("varchar(100)");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasMaxLength(100)
                        .IsUnicode(false)
                        .HasColumnType("varchar(100)");

                    b.Property<string>("Grad")
                        .HasMaxLength(100)
                        .IsUnicode(false)
                        .HasColumnType("varchar(100)");

                    b.Property<string>("Ime")
                        .IsRequired()
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)");

                    b.Property<bool>("JeAktivan")
                        .HasColumnType("bit");

                    b.Property<string>("Prezime")
                        .IsRequired()
                        .HasMaxLength(50)
                        .IsUnicode(false)
                        .HasColumnType("varchar(50)");

                    b.HasKey("ZaposlenikId")
                        .HasName("PK__Zaposlen__3F8CBE150E93A386");

                    b.ToTable("Zaposlenici", (string)null);
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.KorisniciUloge", b =>
                {
                    b.HasOne("VirtualGardens.Services.Database.Korisnici", "Korisnik")
                        .WithMany("KorisniciUloges")
                        .HasForeignKey("KorisnikId")
                        .IsRequired()
                        .HasConstraintName("FKKorisnici_294617");

                    b.HasOne("VirtualGardens.Services.Database.Uloge", "Uloga")
                        .WithMany("KorisniciUloges")
                        .HasForeignKey("UlogaId")
                        .IsRequired()
                        .HasConstraintName("FKKorisnici_243985");

                    b.Navigation("Korisnik");

                    b.Navigation("Uloga");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Nalozi", b =>
                {
                    b.HasOne("VirtualGardens.Services.Database.Zaposlenici", "Zaposlenik")
                        .WithMany("Nalozis")
                        .HasForeignKey("ZaposlenikId")
                        .IsRequired()
                        .HasConstraintName("FKNalozi492203");

                    b.Navigation("Zaposlenik");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Narudzbe", b =>
                {
                    b.HasOne("VirtualGardens.Services.Database.Korisnici", "Korisnik")
                        .WithMany("Narudzbes")
                        .HasForeignKey("KorisnikId")
                        .IsRequired()
                        .HasConstraintName("FKNarudzbe980753");

                    b.HasOne("VirtualGardens.Services.Database.Nalozi", "Nalog")
                        .WithMany("Narudzbes")
                        .HasForeignKey("NalogId")
                        .HasConstraintName("FKNarudzbe309039");

                    b.Navigation("Korisnik");

                    b.Navigation("Nalog");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.PitanjaOdgovori", b =>
                {
                    b.HasOne("VirtualGardens.Services.Database.Korisnici", "Korisnik")
                        .WithMany("PitanjaOdgovoris")
                        .HasForeignKey("KorisnikId")
                        .IsRequired()
                        .HasConstraintName("FKPitanjaOdg350158");

                    b.HasOne("VirtualGardens.Services.Database.Narudzbe", "Narudzba")
                        .WithMany("PitanjaOdgovoris")
                        .HasForeignKey("NarudzbaId")
                        .IsRequired()
                        .HasConstraintName("FKPitanjaOdg958792");

                    b.Navigation("Korisnik");

                    b.Navigation("Narudzba");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Proizvodi", b =>
                {
                    b.HasOne("VirtualGardens.Services.Database.JediniceMjere", "JedinicaMjere")
                        .WithMany("Proizvodis")
                        .HasForeignKey("JedinicaMjereId")
                        .IsRequired()
                        .HasConstraintName("FKProizvodi730772");

                    b.HasOne("VirtualGardens.Services.Database.VrsteProizvodum", "VrstaProizvoda")
                        .WithMany("Proizvodis")
                        .HasForeignKey("VrstaProizvodaId")
                        .IsRequired()
                        .HasConstraintName("FKProizvodi787764");

                    b.Navigation("JedinicaMjere");

                    b.Navigation("VrstaProizvoda");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.ProizvodiSet", b =>
                {
                    b.HasOne("VirtualGardens.Services.Database.Proizvodi", "Proizvod")
                        .WithMany("ProizvodiSets")
                        .HasForeignKey("ProizvodId")
                        .IsRequired()
                        .HasConstraintName("FKProizvodi_145528");

                    b.HasOne("VirtualGardens.Services.Database.Setovi", "Set")
                        .WithMany("ProizvodiSets")
                        .HasForeignKey("SetId")
                        .IsRequired()
                        .HasConstraintName("FKProizvodi_86253");

                    b.Navigation("Proizvod");

                    b.Navigation("Set");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Recenzije", b =>
                {
                    b.HasOne("VirtualGardens.Services.Database.Korisnici", "Korisnik")
                        .WithMany("Recenzijes")
                        .HasForeignKey("KorisnikId")
                        .IsRequired()
                        .HasConstraintName("FKRecenzije432988");

                    b.HasOne("VirtualGardens.Services.Database.Proizvodi", "Proizvod")
                        .WithMany("Recenzijes")
                        .HasForeignKey("ProizvodId")
                        .IsRequired()
                        .HasConstraintName("FKRecenzije100098");

                    b.Navigation("Korisnik");

                    b.Navigation("Proizvod");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Setovi", b =>
                {
                    b.HasOne("VirtualGardens.Services.Database.Narudzbe", "Narudzba")
                        .WithMany("Setovis")
                        .HasForeignKey("NarudzbaId")
                        .IsRequired()
                        .HasConstraintName("FKSetovi958895");

                    b.Navigation("Narudzba");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.SetoviPonude", b =>
                {
                    b.HasOne("VirtualGardens.Services.Database.Ponude", "Ponuda")
                        .WithMany("SetoviPonudes")
                        .HasForeignKey("PonudaId")
                        .IsRequired()
                        .HasConstraintName("FKSetovi_Pon246820");

                    b.HasOne("VirtualGardens.Services.Database.Setovi", "Set")
                        .WithMany("SetoviPonudes")
                        .HasForeignKey("SetId")
                        .IsRequired()
                        .HasConstraintName("FKSetovi_Pon672336");

                    b.Navigation("Ponuda");

                    b.Navigation("Set");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Ulazi", b =>
                {
                    b.HasOne("VirtualGardens.Services.Database.Korisnici", "Korisnik")
                        .WithMany("Ulazis")
                        .HasForeignKey("KorisnikId")
                        .IsRequired()
                        .HasConstraintName("FKUlazi845857");

                    b.Navigation("Korisnik");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.UlaziProizvodi", b =>
                {
                    b.HasOne("VirtualGardens.Services.Database.Proizvodi", "Proizvod")
                        .WithMany("UlaziProizvodis")
                        .HasForeignKey("ProizvodId")
                        .IsRequired()
                        .HasConstraintName("FKUlazi_Proi921157");

                    b.HasOne("VirtualGardens.Services.Database.Ulazi", "Ulaz")
                        .WithMany("UlaziProizvodis")
                        .HasForeignKey("UlazId")
                        .IsRequired()
                        .HasConstraintName("FKUlazi_Proi550210");

                    b.Navigation("Proizvod");

                    b.Navigation("Ulaz");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.JediniceMjere", b =>
                {
                    b.Navigation("Proizvodis");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Korisnici", b =>
                {
                    b.Navigation("KorisniciUloges");

                    b.Navigation("Narudzbes");

                    b.Navigation("PitanjaOdgovoris");

                    b.Navigation("Recenzijes");

                    b.Navigation("Ulazis");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Nalozi", b =>
                {
                    b.Navigation("Narudzbes");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Narudzbe", b =>
                {
                    b.Navigation("PitanjaOdgovoris");

                    b.Navigation("Setovis");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Ponude", b =>
                {
                    b.Navigation("SetoviPonudes");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Proizvodi", b =>
                {
                    b.Navigation("ProizvodiSets");

                    b.Navigation("Recenzijes");

                    b.Navigation("UlaziProizvodis");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Setovi", b =>
                {
                    b.Navigation("ProizvodiSets");

                    b.Navigation("SetoviPonudes");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Ulazi", b =>
                {
                    b.Navigation("UlaziProizvodis");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Uloge", b =>
                {
                    b.Navigation("KorisniciUloges");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.VrsteProizvodum", b =>
                {
                    b.Navigation("Proizvodis");
                });

            modelBuilder.Entity("VirtualGardens.Services.Database.Zaposlenici", b =>
                {
                    b.Navigation("Nalozis");
                });
#pragma warning restore 612, 618
        }
    }
}
