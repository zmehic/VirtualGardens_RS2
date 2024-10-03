using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace VirtualGardens.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "JediniceMjere",
                columns: table => new
                {
                    JedinicaMjereID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Skracenica = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    Opis = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Jedinice__F73C302EAE0341E8", x => x.JedinicaMjereID);
                });

            migrationBuilder.CreateTable(
                name: "Korisnici",
                columns: table => new
                {
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnickoIme = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: false),
                    Ime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Prezime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    BrojTelefona = table.Column<string>(type: "varchar(20)", unicode: false, maxLength: 20, nullable: true),
                    Adresa = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true),
                    Grad = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    Drzava = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    LozinkaHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumRegistracije = table.Column<DateTime>(type: "datetime", nullable: false),
                    ZadnjiLogin = table.Column<DateTime>(type: "datetime", nullable: true),
                    JeAktivan = table.Column<bool>(type: "bit", nullable: false),
                    DatumRodjenja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnic__80B06D616063B1B0", x => x.KorisnikID);
                });

            migrationBuilder.CreateTable(
                name: "Ponude",
                columns: table => new
                {
                    PonudaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Popust = table.Column<int>(type: "int", nullable: true),
                    StateMachine = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Ponude__5AF121B118A3B521", x => x.PonudaID);
                });

            migrationBuilder.CreateTable(
                name: "Uloge",
                columns: table => new
                {
                    UlogaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: false),
                    Opis = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Uloge__DCAB23EB052AF80A", x => x.UlogaID);
                });

            migrationBuilder.CreateTable(
                name: "VrsteProizvoda",
                columns: table => new
                {
                    VrstaProizvodaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__VrstePro__7DC005C03E2A134E", x => x.VrstaProizvodaID);
                });

            migrationBuilder.CreateTable(
                name: "Zaposlenici",
                columns: table => new
                {
                    ZaposlenikID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Email = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: false),
                    Ime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Prezime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    BrojTelefona = table.Column<string>(type: "varchar(20)", unicode: false, maxLength: 20, nullable: true),
                    Adresa = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true),
                    Grad = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    Drzava = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    JeAktivan = table.Column<bool>(type: "bit", nullable: false),
                    DatumRodjenja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Zaposlen__3F8CBE150E93A386", x => x.ZaposlenikID);
                });

            migrationBuilder.CreateTable(
                name: "Ulazi",
                columns: table => new
                {
                    UlazID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    BrojUlaza = table.Column<string>(type: "varchar(20)", unicode: false, maxLength: 20, nullable: false),
                    DatumUlaza = table.Column<DateTime>(type: "datetime", nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Ulazi__732B78ADFE3085BD", x => x.UlazID);
                    table.ForeignKey(
                        name: "FKUlazi845857",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Korisnici_Uloge",
                columns: table => new
                {
                    KorisniciUlogeID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    UlogaID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnic__DF71A2B5F416D0BC", x => x.KorisniciUlogeID);
                    table.ForeignKey(
                        name: "FKKorisnici_243985",
                        column: x => x.UlogaID,
                        principalTable: "Uloge",
                        principalColumn: "UlogaID");
                    table.ForeignKey(
                        name: "FKKorisnici_294617",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Proizvodi",
                columns: table => new
                {
                    ProizvodID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: false),
                    Opis = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true),
                    Cijena = table.Column<float>(type: "real", nullable: false),
                    DostupnaKolicina = table.Column<int>(type: "int", nullable: false),
                    Slika = table.Column<byte[]>(type: "image", nullable: true),
                    JedinicaMjereID = table.Column<int>(type: "int", nullable: false),
                    VrstaProizvodaID = table.Column<int>(type: "int", nullable: false),
                    SlikaThumb = table.Column<byte[]>(type: "image", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Proizvod__21A8BE18421D72EE", x => x.ProizvodID);
                    table.ForeignKey(
                        name: "FKProizvodi730772",
                        column: x => x.JedinicaMjereID,
                        principalTable: "JediniceMjere",
                        principalColumn: "JedinicaMjereID");
                    table.ForeignKey(
                        name: "FKProizvodi787764",
                        column: x => x.VrstaProizvodaID,
                        principalTable: "VrsteProizvoda",
                        principalColumn: "VrstaProizvodaID");
                });

            migrationBuilder.CreateTable(
                name: "Nalozi",
                columns: table => new
                {
                    NalogID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    BrojNaloga = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime", nullable: false),
                    ZaposlenikID = table.Column<int>(type: "int", nullable: false),
                    Zavrsen = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Nalozi__D88333170E63FFCE", x => x.NalogID);
                    table.ForeignKey(
                        name: "FKNalozi492203",
                        column: x => x.ZaposlenikID,
                        principalTable: "Zaposlenici",
                        principalColumn: "ZaposlenikID");
                });

            migrationBuilder.CreateTable(
                name: "Recenzije",
                columns: table => new
                {
                    RecenzijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ocjena = table.Column<int>(type: "int", nullable: false),
                    Komentar = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: false),
                    ProizvodID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Recenzij__D36C60906457BAC9", x => x.RecenzijaID);
                    table.ForeignKey(
                        name: "FKRecenzije100098",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvodi",
                        principalColumn: "ProizvodID");
                    table.ForeignKey(
                        name: "FKRecenzije432988",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Ulazi_Proizvodi",
                columns: table => new
                {
                    UlaziProizvodiID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UlazID = table.Column<int>(type: "int", nullable: false),
                    ProizvodID = table.Column<int>(type: "int", nullable: false),
                    Kolicina = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Ulazi_Pr__8587175320E977CB", x => x.UlaziProizvodiID);
                    table.ForeignKey(
                        name: "FKUlazi_Proi550210",
                        column: x => x.UlazID,
                        principalTable: "Ulazi",
                        principalColumn: "UlazID");
                    table.ForeignKey(
                        name: "FKUlazi_Proi921157",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvodi",
                        principalColumn: "ProizvodID");
                });

            migrationBuilder.CreateTable(
                name: "Narudzbe",
                columns: table => new
                {
                    NarudzbaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    BrojNarudzbe = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: false),
                    Otkazana = table.Column<bool>(type: "bit", nullable: true),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: false),
                    Placeno = table.Column<bool>(type: "bit", nullable: false),
                    StateMachine = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Status = table.Column<bool>(type: "bit", nullable: true),
                    UkupnaCijena = table.Column<int>(type: "int", nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    NalogID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Narudzbe__FBEC135729E59599", x => x.NarudzbaID);
                    table.ForeignKey(
                        name: "FKNarudzbe309039",
                        column: x => x.NalogID,
                        principalTable: "Nalozi",
                        principalColumn: "NalogID");
                    table.ForeignKey(
                        name: "FKNarudzbe980753",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "PitanjaOdgovori",
                columns: table => new
                {
                    PitanjeID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Tekst = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: false),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    NarudzbaID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__PitanjaO__1B924A4E327D27D3", x => x.PitanjeID);
                    table.ForeignKey(
                        name: "FKPitanjaOdg350158",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FKPitanjaOdg958792",
                        column: x => x.NarudzbaID,
                        principalTable: "Narudzbe",
                        principalColumn: "NarudzbaID");
                });

            migrationBuilder.CreateTable(
                name: "Setovi",
                columns: table => new
                {
                    SetID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Cijena = table.Column<int>(type: "int", nullable: false),
                    Popust = table.Column<int>(type: "int", nullable: true),
                    NarudzbaID = table.Column<int>(type: "int", nullable: true),
                    CijenaSaPopustom = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Setovi__7E08473D8E2A49C7", x => x.SetID);
                    table.ForeignKey(
                        name: "FKSetovi958895",
                        column: x => x.NarudzbaID,
                        principalTable: "Narudzbe",
                        principalColumn: "NarudzbaID");
                });

            migrationBuilder.CreateTable(
                name: "Proizvodi_Set",
                columns: table => new
                {
                    ProizvodSetID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ProizvodID = table.Column<int>(type: "int", nullable: false),
                    SetID = table.Column<int>(type: "int", nullable: false),
                    Kolicina = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Proizvod__6D2CD73590593B6D", x => x.ProizvodSetID);
                    table.ForeignKey(
                        name: "FKProizvodi_145528",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvodi",
                        principalColumn: "ProizvodID");
                    table.ForeignKey(
                        name: "FKProizvodi_86253",
                        column: x => x.SetID,
                        principalTable: "Setovi",
                        principalColumn: "SetID");
                });

            migrationBuilder.CreateTable(
                name: "Setovi_Ponude",
                columns: table => new
                {
                    SetoviPonudeID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SetID = table.Column<int>(type: "int", nullable: false),
                    PonudaID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Setovi_P__5012E573A4D76D91", x => x.SetoviPonudeID);
                    table.ForeignKey(
                        name: "FKSetovi_Pon246820",
                        column: x => x.PonudaID,
                        principalTable: "Ponude",
                        principalColumn: "PonudaID");
                    table.ForeignKey(
                        name: "FKSetovi_Pon672336",
                        column: x => x.SetID,
                        principalTable: "Setovi",
                        principalColumn: "SetID");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Korisnici_Uloge_KorisnikID",
                table: "Korisnici_Uloge",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnici_Uloge_UlogaID",
                table: "Korisnici_Uloge",
                column: "UlogaID");

            migrationBuilder.CreateIndex(
                name: "IX_Nalozi_ZaposlenikID",
                table: "Nalozi",
                column: "ZaposlenikID");

            migrationBuilder.CreateIndex(
                name: "IX_Narudzbe_KorisnikID",
                table: "Narudzbe",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Narudzbe_NalogID",
                table: "Narudzbe",
                column: "NalogID");

            migrationBuilder.CreateIndex(
                name: "IX_PitanjaOdgovori_KorisnikID",
                table: "PitanjaOdgovori",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_PitanjaOdgovori_NarudzbaID",
                table: "PitanjaOdgovori",
                column: "NarudzbaID");

            migrationBuilder.CreateIndex(
                name: "IX_Proizvodi_JedinicaMjereID",
                table: "Proizvodi",
                column: "JedinicaMjereID");

            migrationBuilder.CreateIndex(
                name: "IX_Proizvodi_VrstaProizvodaID",
                table: "Proizvodi",
                column: "VrstaProizvodaID");

            migrationBuilder.CreateIndex(
                name: "IX_Proizvodi_Set_ProizvodID",
                table: "Proizvodi_Set",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_Proizvodi_Set_SetID",
                table: "Proizvodi_Set",
                column: "SetID");

            migrationBuilder.CreateIndex(
                name: "IX_Recenzije_KorisnikID",
                table: "Recenzije",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Recenzije_ProizvodID",
                table: "Recenzije",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_Setovi_NarudzbaID",
                table: "Setovi",
                column: "NarudzbaID");

            migrationBuilder.CreateIndex(
                name: "IX_Setovi_Ponude_PonudaID",
                table: "Setovi_Ponude",
                column: "PonudaID");

            migrationBuilder.CreateIndex(
                name: "IX_Setovi_Ponude_SetID",
                table: "Setovi_Ponude",
                column: "SetID");

            migrationBuilder.CreateIndex(
                name: "IX_Ulazi_KorisnikID",
                table: "Ulazi",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Ulazi_Proizvodi_ProizvodID",
                table: "Ulazi_Proizvodi",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_Ulazi_Proizvodi_UlazID",
                table: "Ulazi_Proizvodi",
                column: "UlazID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Korisnici_Uloge");

            migrationBuilder.DropTable(
                name: "PitanjaOdgovori");

            migrationBuilder.DropTable(
                name: "Proizvodi_Set");

            migrationBuilder.DropTable(
                name: "Recenzije");

            migrationBuilder.DropTable(
                name: "Setovi_Ponude");

            migrationBuilder.DropTable(
                name: "Ulazi_Proizvodi");

            migrationBuilder.DropTable(
                name: "Uloge");

            migrationBuilder.DropTable(
                name: "Ponude");

            migrationBuilder.DropTable(
                name: "Setovi");

            migrationBuilder.DropTable(
                name: "Ulazi");

            migrationBuilder.DropTable(
                name: "Proizvodi");

            migrationBuilder.DropTable(
                name: "Narudzbe");

            migrationBuilder.DropTable(
                name: "JediniceMjere");

            migrationBuilder.DropTable(
                name: "VrsteProizvoda");

            migrationBuilder.DropTable(
                name: "Nalozi");

            migrationBuilder.DropTable(
                name: "Korisnici");

            migrationBuilder.DropTable(
                name: "Zaposlenici");
        }
    }
}
