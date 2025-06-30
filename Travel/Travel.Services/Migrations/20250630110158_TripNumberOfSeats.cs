using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Travel.Services.Migrations
{
    /// <inheritdoc />
    public partial class TripNumberOfSeats : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "NumberOfSeats",
                table: "OrganizedTrips",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "NumberOfSeats",
                table: "OrganizedTrips");
        }
    }
}
