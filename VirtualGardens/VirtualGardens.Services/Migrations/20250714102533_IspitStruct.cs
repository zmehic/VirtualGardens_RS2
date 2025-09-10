using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace VirtualGardens.Services.Migrations
{
    /// <inheritdoc />
    public partial class IspitStruct : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Challenges",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PraviloUspjeha = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Tip = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Challenges", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ChallengeRewards",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    IzazovId = table.Column<int>(type: "int", nullable: false),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Tip = table.Column<int>(type: "int", nullable: false),
                    BrojPonavljanja = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ChallengeRewards", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ChallengeRewards_Challenges_IzazovId",
                        column: x => x.IzazovId,
                        principalTable: "Challenges",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PeerChallenges",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikIzazivacId = table.Column<int>(type: "int", nullable: false),
                    KorisnikIzazvaniId = table.Column<int>(type: "int", nullable: false),
                    IzazovId = table.Column<int>(type: "int", nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false),
                    Poruka = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PeerChallenges", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PeerChallenges_Challenges_IzazovId",
                        column: x => x.IzazovId,
                        principalTable: "Challenges",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction);
                    table.ForeignKey(
                        name: "FK_PeerChallenges_Korisnici_KorisnikIzazivacId",
                        column: x => x.KorisnikIzazivacId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID",
                        onDelete: ReferentialAction.NoAction);
                    table.ForeignKey(
                        name: "FK_PeerChallenges_Korisnici_KorisnikIzazvaniId",
                        column: x => x.KorisnikIzazvaniId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserChallenges",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    IzazovId = table.Column<int>(type: "int", nullable: false),
                    DatumPrihvatanja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false),
                    BrojPonavljanja = table.Column<int>(type: "int", nullable: false),
                    VrijemeZavrsetka = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserChallenges", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserChallenges_Challenges_IzazovId",
                        column: x => x.IzazovId,
                        principalTable: "Challenges",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserChallenges_Korisnici_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ChallengeRewards_IzazovId",
                table: "ChallengeRewards",
                column: "IzazovId");

            migrationBuilder.CreateIndex(
                name: "IX_PeerChallenges_IzazovId",
                table: "PeerChallenges",
                column: "IzazovId");

            migrationBuilder.CreateIndex(
                name: "IX_PeerChallenges_KorisnikIzazivacId",
                table: "PeerChallenges",
                column: "KorisnikIzazivacId");

            migrationBuilder.CreateIndex(
                name: "IX_PeerChallenges_KorisnikIzazvaniId",
                table: "PeerChallenges",
                column: "KorisnikIzazvaniId");

            migrationBuilder.CreateIndex(
                name: "IX_UserChallenges_IzazovId",
                table: "UserChallenges",
                column: "IzazovId");

            migrationBuilder.CreateIndex(
                name: "IX_UserChallenges_KorisnikId",
                table: "UserChallenges",
                column: "KorisnikId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ChallengeRewards");

            migrationBuilder.DropTable(
                name: "PeerChallenges");

            migrationBuilder.DropTable(
                name: "UserChallenges");

            migrationBuilder.DropTable(
                name: "Challenges");
        }
    }
}
