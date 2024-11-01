﻿using Microsoft.EntityFrameworkCore.Migrations;

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
            table: "JediniceMjere", // Table name
            columns: new[] { "JedinicaMjereID", "Naziv","Skracenica", "Opis" }, // Column names
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
                    null, "Admin Address", "Admin City", "Admin Country", "cruG+4DBZwMoseY7f3iCNdPh4xI=",
                    "39e7nlx62/4QFBPYi5y7ig==", DateTime.UtcNow, DateTime.UtcNow, true, new DateTime(1990, 1, 1), null
                },
                {
                    2, "zmehic", "zaim.mehic@edu.fit.ba", "Zaim", "Mehic",
                    "061625617", "Bulevar", "Mostar", "BiH", "cruG+4DBZwMoseY7f3iCNdPh4xI=",
                    "39e7nlx62/4QFBPYi5y7ig==", DateTime.UtcNow, DateTime.UtcNow, true, new DateTime(2000, 1, 1), null
                },
                {
                    3, "user", "user@example.com", "Regular", "User",
                    null, "User Address", "User City", "User Country", "cruG+4DBZwMoseY7f3iCNdPh4xI=",
                    "39e7nlx62/4QFBPYi5y7ig==", DateTime.UtcNow, null, true, new DateTime(1995, 5, 5), null
                }
            });

            migrationBuilder.InsertData(
            table: "Korisnici_Uloge",
            columns: new[] { "KorisniciUlogeID", "KorisnikID", "UlogaID" },
            values: new object[,]
            {
                { 1, 2, 1 }, // User with ID 2 as Admin
                { 2, 2, 2 }, // User with ID 2 as Kupac
                { 3, 3, 2 }  // User with ID 3 as Kupac (third user)
            });

            migrationBuilder.InsertData(
            table: "VrsteProizvoda",
            columns: new[] { "VrstaProizvodaID", "Naziv" },
            values: new object[,]
            {
                { 1, "Tlo" },       // Fruit
                { 2, "Prihrana" },     // Vegetable
                { 3, "Sjeme" }        // Meat
            });

            migrationBuilder.InsertData(
            table: "Proizvodi",
            columns: new[] { "ProizvodID", "Naziv", "Opis", "Cijena", "DostupnaKolicina", "JedinicaMjereID", "VrstaProizvodaID" },
            values: new object[,]
            {
                // Soil Products
                { 1, "Kvalitetna Zemlja", "Svježa kvalitetna zemlja za biljke", 2.50f, 100, 1, 1 }, // Soil
                { 2, "Tlo za Cvijeće", "Idealno tlo za cvjetne biljke", 3.00f, 75, 1, 1 }, // Soil
                { 3, "Zemlja za Raste", "Posebno mješavina tla za rastuće biljke", 2.75f, 50, 1, 1 }, // Soil
                
                // Fertilizer Products
                { 4, "Organski Đubrivo", "Prirodno đubrivo za poboljšanje rasta", 5.00f, 60, 2, 2 }, // Fertilizer
                { 5, "Mineralno Đubrivo", "Đubrivo bogato mineralima", 6.00f, 40, 2, 2 }, // Fertilizer
                { 6, "NPK Đubrivo", "NPK đubrivo za optimalan rast biljaka", 4.50f, 80, 2, 2 }, // Fertilizer

                // Seed Products
                { 7, "Sjemenke Rajčice", "Sjemenke za uzgoj rajčice", 1.50f, 200, 1, 3 }, // Seeds
                { 8, "Sjemenke Paprike", "Sjemenke za uzgoj paprike", 1.80f, 180, 1, 3 }, // Seeds
                { 9, "Sjemenke Krastavca", "Sjemenke za uzgoj krastavca", 1.60f, 150, 1, 3 }  // Seeds
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
                    { 1, "Batch-001", DateTime.Now, 1 }, // Admin User with KorisnikId 1
                    { 2, "Batch-002", DateTime.Now.AddDays(-1), 1 }, // Admin User with KorisnikId 1
                    { 3, "Batch-003", DateTime.Now.AddDays(-2), 1 }  // Admin User with KorisnikId 1
                });

            migrationBuilder.InsertData(
               table: "Ulazi_Proizvodi",
               columns: new[] { "UlaziProizvodiID", "UlazID", "ProizvodID", "Kolicina" },
               values: new object[,]
               {
                    { 1, 1, 1, 100 }, // ProizvodId 1 (Soil)
                    { 2, 1, 2, 75 },  // ProizvodId 2 (Fertilizer)
                    { 3, 1, 3, 50 },  // ProizvodId 3 (Seeds)
                    { 4, 2, 4, 60 }, // ProizvodId 4 (Soil)
                    { 5, 2, 5, 40 }, // ProizvodId 5 (Fertilizer)
                    { 6, 2, 6, 80 }, // ProizvodId 6 (Seeds)
                    { 7, 3, 7, 200 },  // ProizvodId 7 (Soil)
                    { 8, 3, 8, 180 }, // ProizvodId 8 (Fertilizer)
                    { 9, 3, 9, 150 }   // ProizvodId 9 (Seeds)
               });

            migrationBuilder.InsertData(
            table: "Nalozi",
            columns: new[] { "NalogID", "BrojNaloga", "DatumKreiranja", "ZaposlenikID", "Zavrsen" },
            values: new object[,]
            {
                { 1, "NAL-001", DateTime.Now, 1, false }, // Assuming ZaposlenikId 1 exists
                { 2, "NAL-002", DateTime.Now, 2, false }, // Assuming ZaposlenikId 2 exists
                { 3, "NAL-003", DateTime.Now, 3, false }  // Assuming ZaposlenikId 3 exists
            });

            migrationBuilder.InsertData(
            table: "Narudzbe",
            columns: new[] { "NarudzbaID", "BrojNarudzbe", "Otkazana", "Datum", "Placeno", "StateMachine", "Status", "UkupnaCijena", "KorisnikID", "NalogID" },
            values: new object[,]
            {
                { 1, "NAR-001", false, DateTime.Now, false, "created", null, 150, 1, 1 }, // Assuming KorisnikId 1 and NalogId 1 exist
                { 2, "NAR-002", false, DateTime.Now, false, "created", null, 300, 2, 2 }, // Assuming KorisnikId 2 and NalogId 2 exist
                { 3, "NAR-003", true, DateTime.Now, false, "finished", null, 200, 3, null },  // Assuming KorisnikId 3 exists, no NalogId
                { 4, "NAR-004", false, DateTime.Now, true, "finished", null, 400, 1, 1 }, // Assuming KorisnikId 1 and NalogId 1 exist
                { 5, "NAR-005", false, DateTime.Now, false, "created", null, 250, 2, null } // Assuming KorisnikId 2 exists, no NalogId
            });

            migrationBuilder.InsertData(
            table: "PitanjaOdgovori",
            columns: new[] { "PitanjeID", "Tekst", "Datum", "KorisnikID", "NarudzbaID" },
            values: new object[,]
            {
                { 1, "When will my order be delivered?", DateTime.Now, 1, 1 }, // Assuming KorisnikId 1 and NarudzbaId 1 exist
                { 2, "Is there a way to track my order?", DateTime.Now, 2, 2 }, // Assuming KorisnikId 2 and NarudzbaId 2 exist
                { 3, "Can I change my delivery address?", DateTime.Now, 3, 3 }, // Assuming KorisnikId 3 and NarudzbaId 3 exist
                { 4, "What is your return policy?", DateTime.Now, 1, 4 }, // Assuming KorisnikId 1 and NarudzbaId 4 exist
                { 5, "Do you offer discounts for bulk purchases?", DateTime.Now, 2, 5 } // Assuming KorisnikId 2 and NarudzbaId 5 exist
            });

            migrationBuilder.InsertData(
            table: "Ponude",
            columns: new[] { "PonudaID", "Naziv", "Popust", "StateMachine", "DatumKreiranja" },
            values: new object[,]
            {
                { 1, "Spring Sale", 15, "created", DateTime.Now },
                { 2, "Summer Special", 20, "created", DateTime.Now },
                { 3, "Fall Discount", 10, "created", DateTime.Now },
                { 4, "Winter Clearance", 25, "created", DateTime.Now },
                { 5, "Holiday Offer", 30, "created", DateTime.Now }
            });

            migrationBuilder.InsertData(
            table: "Setovi",
            columns: new[] { "SetID", "Cijena", "Popust", "NarudzbaID", "CijenaSaPopustom" },
            values: new object[,]
            {
                { 1, 100, 10, null, 90 },
                { 2, 150, 15, null, 135 },
                { 3, 200, 20, null, 180 },
                { 4, 250, null, null, 250 },
                { 5, 300, 25, null, 275 }
            });

            migrationBuilder.InsertData(
            table: "Proizvodi_Set",
            columns: new[] { "ProizvodSetID", "ProizvodID", "SetID", "Kolicina" },
            values: new object[,]
            {
                { 1, 1, 1, 10 }, // 10 units of product 1 in set 1
                { 2, 2, 1, 5 },  // 5 units of product 2 in set 1
                { 3, 3, 2, 8 },  // 8 units of product 3 in set 2
                { 4, 4, 2, 3 },  // 3 units of product 4 in set 2
                { 5, 5, 3, 7 },  // 7 units of product 5 in set 3
                { 6, 1, 3, 4 },  // 4 units of product 1 in set 3
                { 7, 2, 3, 6 }   // 6 units of product 2 in set 3
            });

            migrationBuilder.InsertData(
            table: "Recenzije",
            columns: new[] { "RecenzijaID", "Ocjena", "Komentar", "KorisnikID", "Datum", "ProizvodID" },
            values: new object[,]
            {
                { 1, 5, "Excellent product! Highly recommend.", 1, DateTime.Now, 1 }, // Review for product 1 by user 1
                { 2, 4, "Very good quality, but a bit pricey.", 2, DateTime.Now, 2 },  // Review for product 2 by user 2
                { 3, 3, "Average product, nothing special.", 3, DateTime.Now, 3 },   // Review for product 3 by user 3
                { 4, 2, "Not satisfied with the quality.", 1, DateTime.Now, 4 },      // Review for product 4 by user 1
                { 5, 5, "Best purchase I've made this year!", 2, DateTime.Now, 5 },  // Review for product 5 by user 2
                { 6, 1, "Terrible experience, will not buy again.", 3, DateTime.Now, 1 }, // Review for product 1 by user 3
                { 7, 4, "Good value for the price.", 1, DateTime.Now, 2 },           // Review for product 2 by user 1
                { 8, 3, "Okay product, works as expected.", 2, DateTime.Now, 3 }     // Review for product 3 by user 2
            });

            migrationBuilder.InsertData(
            table: "Setovi_Ponude",
            columns: new[] { "SetoviPonudeID", "SetID", "PonudaID" },
            values: new object[,]
            {
                { 1, 1, 1 }, // Set 1 associated with Offer 1
                { 2, 1, 2 }, // Set 1 associated with Offer 2
                { 3, 2, 1 }, // Set 2 associated with Offer 1
                { 4, 3, 3 }, // Set 3 associated with Offer 3
                { 5, 2, 2 }, // Set 2 associated with Offer 2
                { 6, 3, 1 }  // Set 3 associated with Offer 1
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
                keyValue: 3); // Add this line to remove the third user during rollback

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
                table: "Narudzbe",
                keyColumn: "NarudzbaID",
                keyValue: 5);

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
                table: "Ponude",
                keyColumn: "PonudaID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Ponude",
                keyColumn: "PonudaID",
                keyValue: 5);

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
           table: "Proizvodi_Set",
           keyColumn: "ProizvodSetID",
           keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Proizvodi_Set",
                keyColumn: "ProizvodSetID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Proizvodi_Set",
                keyColumn: "ProizvodSetID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Proizvodi_Set",
                keyColumn: "ProizvodSetID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Proizvodi_Set",
                keyColumn: "ProizvodSetID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Proizvodi_Set",
                keyColumn: "ProizvodSetID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Proizvodi_Set",
                keyColumn: "ProizvodSetID",
                keyValue: 7);

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

            migrationBuilder.DeleteData(
                table: "Setovi_Ponude",
                keyColumn: "SetoviPonudeID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Setovi_Ponude",
                keyColumn: "SetoviPonudeID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Setovi_Ponude",
                keyColumn: "SetoviPonudeID",
                keyValue: 6);
        }
    }
 }

