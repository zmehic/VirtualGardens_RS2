using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace VirtualGardens.Services.Migrations
{
    /// <inheritdoc />
    public partial class LoznikaHashSalt : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "LozinkaHash",
                table: "Korisnici",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "LozinkaSalt",
                table: "Korisnici",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "LozinkaHash",
                table: "Korisnici");

            migrationBuilder.DropColumn(
                name: "LozinkaSalt",
                table: "Korisnici");
        }
    }
}
