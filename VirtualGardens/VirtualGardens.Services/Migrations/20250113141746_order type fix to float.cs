using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace VirtualGardens.Services.Migrations
{
    /// <inheritdoc />
    public partial class ordertypefixtofloat : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<float>(
                name: "UkupnaCijena",
                table: "Narudzbe",
                type: "real",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<int>(
                name: "UkupnaCijena",
                table: "Narudzbe",
                type: "int",
                nullable: false,
                oldClrType: typeof(float),
                oldType: "real");
        }
    }
}
