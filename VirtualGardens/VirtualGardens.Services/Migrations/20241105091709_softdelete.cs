using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace VirtualGardens.Services.Migrations
{
    /// <inheritdoc />
    public partial class softdelete : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Zaposlenici",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Zaposlenici",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "VrsteProizvoda",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "VrsteProizvoda",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Uloge",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Uloge",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Ulazi_Proizvodi",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Ulazi_Proizvodi",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Ulazi",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Ulazi",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Setovi_Ponude",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Setovi_Ponude",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Setovi",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Setovi",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Recenzije",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Recenzije",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Proizvodi_Set",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Proizvodi_Set",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Proizvodi",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Proizvodi",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Ponude",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Ponude",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "PitanjaOdgovori",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "PitanjaOdgovori",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Narudzbe",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Narudzbe",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Nalozi",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Nalozi",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Korisnici_Uloge",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Korisnici_Uloge",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Korisnici",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "Korisnici",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "JediniceMjere",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "JediniceMjere",
                type: "datetime2",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Zaposlenici");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Zaposlenici");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "VrsteProizvoda");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "VrsteProizvoda");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Uloge");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Uloge");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Ulazi_Proizvodi");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Ulazi_Proizvodi");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Ulazi");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Ulazi");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Setovi_Ponude");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Setovi_Ponude");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Setovi");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Setovi");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Recenzije");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Recenzije");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Proizvodi_Set");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Proizvodi_Set");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Proizvodi");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Proizvodi");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Ponude");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Ponude");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "PitanjaOdgovori");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "PitanjaOdgovori");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Narudzbe");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Narudzbe");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Nalozi");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Nalozi");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Korisnici_Uloge");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Korisnici_Uloge");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Korisnici");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "Korisnici");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "JediniceMjere");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "JediniceMjere");
        }
    }
}
