using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Travel.Services.Migrations
{
    /// <inheritdoc />
    public partial class Fixes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "NumberOfPassengers",
                table: "RouteTickets",
                newName: "NumberOfChildPassengers");

            migrationBuilder.AddColumn<int>(
                name: "NumberOfAdultPassengers",
                table: "RouteTickets",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "NumberOfAdultPassengers",
                table: "RouteTickets");

            migrationBuilder.RenameColumn(
                name: "NumberOfChildPassengers",
                table: "RouteTickets",
                newName: "NumberOfPassengers");
        }
    }
}
