using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace VirtualGardens.Services.Migrations
{
    /// <inheritdoc />
    public partial class SeedDataMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
            table: "JediniceMjere", 
            columns: new[] { "JedinicaMjereID", "Naziv","Skracenica", "Opis" }, 
            values: new object[,]
            {
                { 1, "Kilogram","kg", null },
                { 2, "Gram", "g", null },
                { 3, "Litar", "l", null }
            });

            migrationBuilder.InsertData(
            table: "Uloge",
            columns: new[] { "UlogaID", "Naziv", "Opis" },
            values: new object[,]
            {
                { 1, "Admin", null },
                { 2, "Kupac", null },
            });

            migrationBuilder.InsertData(
            table: "Korisnici",
            columns: new[]
            {
                "KorisnikID", "KorisnickoIme", "Email", "Ime", "Prezime",
                "BrojTelefona", "Adresa", "Grad", "Drzava", "LozinkaHash",
                "LozinkaSalt", "DatumRegistracije", "ZadnjiLogin", "JeAktivan", "DatumRodjenja", "Slika"
            },
            values: new object[,]
            {
                {
                    1, "admin", "admin@example.com", "Admin", "User",
                    null, "Admin Address", "Admin City", "Admin Country", "tVeXz/bhKIFIANPp0WrD4I0NPpo=",
                    "P2W0L0dMofP7yH0SvCzeyA==", DateTime.UtcNow, DateTime.UtcNow, true, new DateTime(1990, 1, 1), null
                },
                {
                    2, "zmehic", "zaim.mehic@edu.fit.ba", "Zaim", "Mehic",
                    "061625617", "Bulevar", "Mostar", "BiH", "tVeXz/bhKIFIANPp0WrD4I0NPpo=",
                    "P2W0L0dMofP7yH0SvCzeyA==", DateTime.UtcNow, DateTime.UtcNow, true, new DateTime(2000, 1, 1), null
                },
                {
                    3, "user", "user@example.com", "Regular", "User",
                    null, "User Address", "User City", "User Country", "tVeXz/bhKIFIANPp0WrD4I0NPpo=",
                    "P2W0L0dMofP7yH0SvCzeyA==", DateTime.UtcNow, null, true, new DateTime(1995, 5, 5), null
                }
            });

            migrationBuilder.InsertData(
            table: "Korisnici_Uloge",
            columns: new[] { "KorisniciUlogeID", "KorisnikID", "UlogaID" },
            values: new object[,]
            {
                { 1, 1, 1 }, 
                { 2, 2, 2 }, 
                { 3, 3, 2 }  
            });

            migrationBuilder.InsertData(
            table: "VrsteProizvoda",
            columns: new[] { "VrstaProizvodaID", "Naziv" },
            values: new object[,]
            {
                { 1, "Tlo" },      
                { 2, "Prihrana" }, 
                { 3, "Sjeme" }     
            });

            migrationBuilder.InsertData(
            table: "Proizvodi",
            columns: new[] { "ProizvodID", "Naziv", "Opis", "Cijena", "DostupnaKolicina", "JedinicaMjereID", "VrstaProizvodaID" },
            values: new object[,]
            {

                { 1, "Kvalitetna Zemlja", "Svježa kvalitetna zemlja za biljke", 2.50f, 1000, 1, 1 },
                { 2, "Tlo za Cvijeće", "Idealno tlo za cvjetne biljke", 3.00f, 750, 1, 1 },
                { 3, "Zemlja za Raste", "Posebno mješavina tla za rastuće biljke", 2.75f, 500, 1, 1 }, 
                { 4, "Zemlja za cvijeće 2", "Svježa kvalitetna zemlja za cvijeće", 2.50f, 1000, 1, 1 },
                { 5, "Tlo za Paradajz", "Idealno tlo za paradajz", 3.00f, 750, 1, 1 }, 
                { 6, "Zemlja za Kukuruz", "Posebno mješavina tla za kukuruz", 2.75f, 500, 1, 1 },
                { 7, "Kvalitetna Zemlja za Paprike", "Svježa kvalitetna zemlja za paprike", 2.50f, 1000, 1, 1 },
                { 8, "Tlo za Cvijeće 2", "Idealno tlo za cvjetne biljke", 3.00f, 750, 1, 1 }, 
                { 9, "Zemlja za Raste 2", "Posebno mješavina tla za rastuće biljke", 2.75f, 500, 1, 1 }, 
                
                { 10, "Organski Đubrivo", "Prirodno đubrivo za poboljšanje rasta", 5.00f, 600, 2, 2 },  
                { 11, "Mineralno Đubrivo", "Đubrivo bogato mineralima", 6.00f, 400, 2, 2 }, 
                { 12, "NPK Đubrivo", "NPK đubrivo za optimalan rast biljaka", 4.50f, 800, 2, 2 },
                { 13, "Organski Đubrivo 2", "Prirodno đubrivo za poboljšanje rasta", 5.00f, 600, 2, 2 }, 
                { 14, "Mineralno Đubrivo 2", "Đubrivo bogato mineralima", 6.00f, 400, 2, 2 }, 
                { 15, "NPK Đubrivo 2", "NPK đubrivo za optimalan rast biljaka", 4.50f, 800, 2, 2 }, 
                { 16, "Organski Đubrivo 3", "Prirodno đubrivo za poboljšanje rasta", 5.00f, 600, 2, 2 }, 
                { 17, "Mineralno Đubrivo 3", "Đubrivo bogato mineralima", 6.00f, 400, 2, 2 }, 
                { 18, "NPK Đubrivo 3", "NPK đubrivo za optimalan rast biljaka", 4.50f, 800, 2, 2 }, 

                { 19, "Sjemenke Rajčice", "Sjemenke za uzgoj rajčice", 1.50f, 2000, 1, 3 }, 
                { 20, "Sjemenke Paprike", "Sjemenke za uzgoj paprike", 1.80f, 1800, 1, 3 }, 
                { 21, "Sjemenke Krastavca", "Sjemenke za uzgoj krastavca", 1.60f, 1500, 1, 3 } , 
                { 22, "Sjemenke Kukuruza", "Sjemenke za uzgoj rajčice", 1.50f, 2000, 1, 3 }, 
                { 23, "Sjemenke Mahune", "Sjemenke za uzgoj paprike", 1.80f, 1800, 1, 3 }, 
                { 24, "Sjemenke Graška", "Sjemenke za uzgoj krastavca", 1.60f, 1500, 1, 3 } ,
                { 25, "Sjemenke Mrkve", "Sjemenke za uzgoj rajčice", 1.50f, 2000, 1, 3 },
                { 26, "Sjemenke Špinata", "Sjemenke za uzgoj paprike", 1.80f, 1800, 1, 3 },
                { 27, "Sjemenke Blitve", "Sjemenke za uzgoj krastavca", 1.60f, 1500, 1, 3 }  
            });

            migrationBuilder.InsertData(
                table: "Zaposlenici",
                columns: new[] { "ZaposlenikID", "Email", "Ime", "Prezime", "BrojTelefona", "Adresa", "Grad", "Drzava", "JeAktivan", "DatumRodjenja" },
                values: new object[,]
                {
                    { 1, "marko.novak@example.com", "Marko", "Novak", "0123456789", "Adresa 1", "Grad 1", "Država 1", true, new DateTime(1990, 5, 20) },
                    { 2, "ivan.kovac@example.com", "Ivan", "Kovač", "0987654321", "Adresa 2", "Grad 2", "Država 2", true, new DateTime(1985, 3, 15) },
                    { 3, "ana.petrovic@example.com", "Ana", "Petrović", "0135792468", "Adresa 3", "Grad 3", "Država 3", true, new DateTime(1992, 8, 30) }
                });

            migrationBuilder.InsertData(
                table: "Ulazi",
                columns: new[] { "UlazID", "BrojUlaza", "DatumUlaza", "KorisnikID" },
                values: new object[,]
                {
                    { 1, "Batch-1", DateTime.Now, 1 }, 
                    { 2, "Batch-2", DateTime.Now.AddDays(-1), 1 }, 
                    { 3, "Batch-3", DateTime.Now.AddDays(-2), 1 }  
                });

            migrationBuilder.InsertData(
               table: "Ulazi_Proizvodi",
               columns: new[] { "UlaziProizvodiID", "UlazID", "ProizvodID", "Kolicina" },
               values: new object[,]
               {
                    { 1, 1, 1, 1000 }, 
                    { 2, 1, 2, 750 },  
                    { 3, 1, 3, 500 },  
                    { 4, 1, 4, 1000 },
                    { 5, 1, 5, 750 }, 
                    { 6, 1, 6, 500 }, 
                    { 7, 1, 7, 1000 },  
                    { 8, 1, 8, 750 }, 
                    { 9, 1, 9, 500 },  
                    { 10, 2, 10, 600 }, 
                    { 11, 2, 11, 400 }, 
                    { 12, 2, 12, 800 }, 
                    { 13, 2, 13, 600 }, 
                    { 14, 2, 14, 400 }, 
                    { 15, 2, 15, 800 }, 
                    { 16, 2, 16, 600},  
                    { 17, 2, 17, 400 }, 
                    { 18, 2, 18, 800 }, 
                    { 19, 3, 19, 2000 },
                    { 20, 3, 20, 1800 },
                    { 21, 3, 21, 1500 },
                    { 22, 3, 22, 2000 },
                    { 23, 3, 23, 1800 },
                    { 24, 3, 24, 1500 },
                    { 25, 3, 25, 2000 },
                    { 26, 3, 26, 1800 },
                    { 27, 3, 27, 1500 },
               });

            migrationBuilder.InsertData(
            table: "Nalozi",
            columns: new[] { "NalogID", "BrojNaloga", "DatumKreiranja", "ZaposlenikID", "Zavrsen" },
            values: new object[,]
            {
                { 1, "NAL-1", DateTime.Now, 1, false },
                { 2, "NAL-2", DateTime.Now, 2, false },
                { 3, "NAL-3", DateTime.Now, 3, false } 
            });

            migrationBuilder.InsertData(
            table: "Narudzbe",
            columns: new[] { "NarudzbaID", "BrojNarudzbe", "Otkazana", "Datum", "Placeno", "StateMachine", "Status", "UkupnaCijena", "KorisnikID", "NalogID" },
            values: new object[,]
            {
                { 1, "NAR-1", false, DateTime.Now, true, "finished", null, 1669.6, 3, 2 },
                { 2, "NAR-2", false, DateTime.Now, true, "inprogress", null, 725.6, 3, 1 },
                { 3, "NAR-3", false, DateTime.Now, true, "inprogress", null, 576.15, 3, 1 },
                { 4, "NAR-4", false, DateTime.Now, false, "created", null, 0, 3, null}
                });

            migrationBuilder.InsertData(
            table: "PitanjaOdgovori",
            columns: new[] { "PitanjeID", "Tekst", "Datum", "KorisnikID", "NarudzbaID" },
            values: new object[,]
            {
                { 1, "When will my order be delivered?", DateTime.Now, 2, 1 },
                { 2, "Is there a way to track my order?", DateTime.Now, 2, 2 },
                { 3, "Can I change my delivery address?", DateTime.Now, 3, 3 },
                { 4, "What is your return policy?", DateTime.Now, 3, 1 },
                { 5, "Do you offer discounts for bulk purchases?", DateTime.Now, 2, 2 }
            });

            migrationBuilder.InsertData(
            table: "Ponude",
            columns: new[] { "PonudaID", "Naziv", "Popust", "StateMachine", "DatumKreiranja" },
            values: new object[,]
            {
                { 1, "Proljetna ponuda", 20, "created", DateTime.Now },
                 { 2, "Proljetna ponuda 2", 30, "active", DateTime.Now },
                  { 3, "Proljetna ponuda 3", 10, "finished", DateTime.Now },
            });

            migrationBuilder.InsertData(
             table: "Setovi",
             columns: new[] { "SetID", "Cijena", "Popust", "NarudzbaID", "CijenaSaPopustom" },
             values: new object[,]
             {
                { 1, 90, 20, null, 72 },
                { 2, 88.5, 30, null, 61.9 },
                { 3, 100, 10, null, 90 },
                { 4, 95, 0, 1, 95 },
                { 5, 207, 0, 1, 207 },
                { 6, 103.5, 0, 1, 103.5 },
                { 7, 206, 0, 1, 206 },
                { 8, 222, 0, 1, 222 },
                { 9, 118.6, 0, 1, 118.6 },
                { 10, 111.1, 0, 1, 111.1 },
                { 11, 182, 0, 1, 182 },
                { 12, 300.6, 0, 1, 300.6 },
                { 13, 88.5, 30, 1, 61.9 },
                { 14, 88.5, 30, 1, 61.9 },
                { 15, 57, 0, 2, 57 },
                { 16, 39.8, 0, 2, 39.8 },
                { 17, 141.1, 0, 2, 141.1 },
                { 18, 146.5, 0, 2, 146.5 },
                { 19, 38, 0, 2, 38 },
                { 20, 27.4, 0, 2, 27.4 },
                { 21, 49.5, 0, 2, 49.5 },
                { 22, 47.8, 0, 2, 47.8 },
                { 23, 116.6, 0, 2, 116.6 },
                { 24, 88.5, 30, 2, 61.9 },
                { 25, 35.5, 0, 3, 35.5 },
                { 26, 130.1, 0, 3, 130.1 },
                { 27, 9.35, 0, 3, 9.35 },
                { 28, 19, 0, 3, 19 },
                { 29, 191.95, 0, 3, 191.95 },
                { 30, 48.7, 0, 3, 48.7 },
                { 31, 26, 0, 3, 26 },
                { 32, 93.95, 0, 3, 93.95 },
                { 33, 21.6, 0, 3, 21.6 },
             });


            migrationBuilder.InsertData(
                table: "Proizvodi_Set",
                columns: new[] { "ProizvodSetID", "ProizvodID", "SetID", "Kolicina" },
                values: new object[,]
                {
                    { 1, 1, 1, 10 },
                    { 2, 19, 1, 10 },
                    { 3, 10, 1, 10 },
                    { 4, 3, 2, 10 },
                    { 5, 21, 2, 10 },
                    { 6, 12, 2, 10 },
                    { 7, 4, 3, 10 },
                    { 8, 22, 3, 10 },
                    { 9, 14, 3, 10 },
                    { 10, 19, 4, 10 },
                    { 11, 10, 4, 10 },
                    { 12, 2, 4, 10 },
                    { 13, 21, 5, 20 },
                    { 14, 11, 5, 20 },
                    { 15, 3, 5, 20 },
                    { 16, 23, 6, 10 },
                    { 17, 18, 6, 11 },
                    { 18, 2, 6, 12 },
                    { 19, 20, 7, 20 },
                    { 20, 17, 7, 20 },
                    { 21, 7, 7, 20 },
                    { 22, 22, 8, 10 },
                    { 23, 10, 8, 15 },
                    { 24, 5, 8, 44 },
                    { 25, 23, 9, 12 },
                    { 26, 15, 9, 13 },
                    { 27, 9, 9, 14 },
                    { 28, 24, 10, 11 },
                    { 29, 11, 10, 11 },
                    { 30, 4, 10, 11 },
                    { 31, 25, 11, 54 },
                    { 32, 10, 11, 13 },
                    { 33, 2, 11, 12 },
                    { 34, 27, 12, 11 },
                    { 35, 13, 12, 44 },
                    { 36, 2, 12, 21 },
                    { 37, 3, 13, 10 },
                    { 38, 21, 13, 10 },
                    { 39, 12, 13, 10 },
                    { 40, 3, 14, 10 },
                    { 41, 21, 14, 10 },
                    { 42, 12, 14, 10 },
                    { 43, 19, 15, 5 },
                    { 44, 14, 15, 7 },
                    { 45, 1, 15, 3 },
                    { 46, 20, 16, 11 },
                    { 47, 12, 16, 2 },
                    { 48, 9, 16, 4 },
                    { 49, 21, 17, 11 },
                    { 50, 18, 17, 3 },
                    { 51, 1, 17, 44 },
                    { 52, 22, 18, 1 },
                    { 53, 14, 18, 4 },
                    { 54, 9, 18, 44 },
                    { 55, 23, 19, 5 },
                    { 56, 10, 19, 4 },
                    { 57, 5, 19, 3 },
                    { 58, 24, 20, 4 },
                    { 59, 14, 20, 3 },
                    { 60, 2, 20, 1 },
                    { 61, 25, 21, 22 },
                    { 62, 18, 21, 2 },
                    { 63, 1, 21, 3 },
                    { 64, 26, 22, 11 },
                    { 65, 14, 22, 3 },
                    { 66, 1, 22, 4 },
                    { 67, 27, 23, 11 },
                    { 68, 17, 23, 11 },
                    { 69, 5, 23, 11 },
                    { 70, 3, 24, 10 },
                    { 71, 21, 24, 10 },
                    { 72, 12, 24, 10 },
                    { 73, 19, 25, 11 },
                    { 74, 10, 25, 2 },
                    { 75, 2, 25, 3 },
                    { 76, 20, 26, 2 },
                    { 77, 12, 26, 22 },
                    { 78, 4, 26, 11 },
                    { 79, 21, 27, 1 },
                    { 80, 16, 27, 1 },
                    { 81, 9, 27, 1 },
                    { 82, 22, 28, 4 },
                    { 83, 13, 28, 2 },
                    { 84, 2, 28, 1 },
                    { 85, 23, 29, 44 },
                    { 86, 13, 29, 22 },
                    { 87, 9, 29, 1 },
                    { 88, 24, 30, 22 },
                    { 89, 17, 30, 1 },
                    { 90, 1, 30, 3 },
                    { 91, 25, 31, 11 },
                    { 92, 15, 31, 1 },
                    { 93, 1, 31, 2 },
                    { 94, 26, 32, 44 },
                    { 95, 14, 32, 2 },
                    { 96, 9, 32, 1 },
                    { 97, 27, 33, 1 },
                    { 98, 16, 33, 2 },
                    { 99, 1, 33, 4 },
                            });


            migrationBuilder.InsertData(
            table: "Recenzije",
            columns: new[] { "RecenzijaID", "Ocjena", "Komentar", "KorisnikID", "Datum", "ProizvodID" },
            values: new object[,]
            {
                { 1, 5, "Excellent product! Highly recommend.", 2, DateTime.Now, 1 }, 
                { 2, 4, "Very good quality, but a bit pricey.", 2, DateTime.Now, 2 }, 
                { 3, 3, "Average product, nothing special.", 3, DateTime.Now, 2 },   
                { 4, 2, "Not satisfied with the quality.", 2, DateTime.Now, 4 },      
                { 5, 5, "Best purchase I've made this year!", 2, DateTime.Now, 5 }, 
                { 6, 1, "Terrible experience, will not buy again.", 3, DateTime.Now, 6 },
                { 7, 4, "Good value for the price.", 2, DateTime.Now, 8 },           
                { 8, 3, "Okay product, works as expected.", 2, DateTime.Now, 8 }     
            });

            migrationBuilder.InsertData(
            table: "Setovi_Ponude",
            columns: new[] { "SetoviPonudeID", "SetID", "PonudaID" },
            values: new object[,]
            {
                { 1, 1, 1 }, 
                { 2, 2, 2 },
                { 3, 3, 3 }, 

            });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
            table: "JediniceMjere",
            keyColumn: "JedinicaMjereID",
            keyValues: new object[] { 1, 2, 3 });

            migrationBuilder.DeleteData(
            table: "Uloge",
            keyColumn: "UlogaID",
            keyValues: new object[] { 1, 2});

            migrationBuilder.DeleteData(
            table: "Korisnici",
            keyColumn: "KorisnikID",
            keyValues: new object[] { 1, 2, 3 });

            migrationBuilder.DeleteData(
            table: "Korisnici_Uloge",
            keyColumn: "KorisniciUlogeID",
            keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Korisnici_Uloge",
                keyColumn: "KorisniciUlogeID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Korisnici_Uloge",
                keyColumn: "KorisniciUlogeID",
                keyValue: 3);

            migrationBuilder.DeleteData(
            table: "VrsteProizvoda",
            keyColumn: "VrstaProizvodaID",
            keyValue: 1);

            migrationBuilder.DeleteData(
                table: "VrsteProizvoda",
                keyColumn: "VrstaProizvodaID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "VrsteProizvoda",
                keyColumn: "VrstaProizvodaID",
                keyValue: 3);

            migrationBuilder.DeleteData(
            table: "Proizvodi",
            keyColumn: "ProizvodID",
            keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 9);

            migrationBuilder.DeleteData(
            table: "Proizvodi",
            keyColumn: "ProizvodID",
            keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 18);

            migrationBuilder.DeleteData(
            table: "Proizvodi",
            keyColumn: "ProizvodID",
            keyValue: 19);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 25);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 26);

            migrationBuilder.DeleteData(
                table: "Proizvodi",
                keyColumn: "ProizvodID",
                keyValue: 27);

            migrationBuilder.DeleteData(
            table: "Zaposlenici",
            keyColumn: "ZaposlenikID",
            keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Zaposlenici",
                keyColumn: "ZaposlenikID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Zaposlenici",
                keyColumn: "ZaposlenikID",
                keyValue: 3);

            migrationBuilder.DeleteData(
            table: "Ulazi",
            keyColumn: "UlazID",
            keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Ulazi",
                keyColumn: "UlazID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Ulazi",
                keyColumn: "UlazID",
                keyValue: 3);

            migrationBuilder.DeleteData(
            table: "Ulazi_Proizvodi",
            keyColumn: "UlaziProizvodiID",
            keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 25);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 26);

            migrationBuilder.DeleteData(
                table: "Ulazi_Proizvodi",
                keyColumn: "UlaziProizvodiID",
                keyValue: 27);

            migrationBuilder.DeleteData(
            table: "Nalozi",
            keyColumn: "NalogID",
            keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Nalozi",
                keyColumn: "NalogID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Nalozi",
                keyColumn: "NalogID",
                keyValue: 3);

            migrationBuilder.DeleteData(
            table: "Narudzbe",
            keyColumn: "NarudzbaID",
            keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Narudzbe",
                keyColumn: "NarudzbaID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Narudzbe",
                keyColumn: "NarudzbaID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Narudzbe",
                keyColumn: "NarudzbaID",
                keyValue: 4);


            migrationBuilder.DeleteData(
            table: "PitanjaOdgovori",
            keyColumn: "PitanjeID",
            keyValue: 1);

            migrationBuilder.DeleteData(
                table: "PitanjaOdgovori",
                keyColumn: "PitanjeID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "PitanjaOdgovori",
                keyColumn: "PitanjeID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "PitanjaOdgovori",
                keyColumn: "PitanjeID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "PitanjaOdgovori",
                keyColumn: "PitanjeID",
                keyValue: 5);

            migrationBuilder.DeleteData(
            table: "Ponude",
            keyColumn: "PonudaID",
            keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Ponude",
                keyColumn: "PonudaID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Ponude",
                keyColumn: "PonudaID",
                keyValue: 3);


            migrationBuilder.DeleteData(
           table: "Setovi",
           keyColumn: "SetID",
           keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 25);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 26);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 27);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 28);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 29);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 30);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 31);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 32);

            migrationBuilder.DeleteData(
                table: "Setovi",
                keyColumn: "SetID",
                keyValue: 33);

            for (int i = 1; i <= 99; i++)
            {
                migrationBuilder.DeleteData(
                    table: "Proizvodi_Set",
                    keyColumn: "ProizvodSetID",
                    keyValue: i);
            }

            migrationBuilder.DeleteData(
            table: "Recenzije",
            keyColumn: "RecenzijaID",
            keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "RecenzijaID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "RecenzijaID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "RecenzijaID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "RecenzijaID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "RecenzijaID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "RecenzijaID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Recenzije",
                keyColumn: "RecenzijaID",
                keyValue: 8);

            migrationBuilder.DeleteData(
           table: "Setovi_Ponude",
           keyColumn: "SetoviPonudeID",
           keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Setovi_Ponude",
                keyColumn: "SetoviPonudeID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Setovi_Ponude",
                keyColumn: "SetoviPonudeID",
                keyValue: 3);

        }
    }
 }

