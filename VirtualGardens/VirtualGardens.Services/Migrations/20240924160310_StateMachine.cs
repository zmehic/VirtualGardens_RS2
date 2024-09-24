using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace VirtualGardens.Services.Migrations
{
    /// <inheritdoc />
    public partial class StateMachine : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "StateMachine",
                table: "Narudzbe",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "StateMachine",
                table: "Narudzbe");
        }
    }
}
