using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Travel.Services.Migrations
{
    /// <inheritdoc />
    public partial class newfields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "AgencyId",
                table: "RouteTickets",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            migrationBuilder.CreateIndex(
                name: "IX_RouteTickets_AgencyId",
                table: "RouteTickets",
                column: "AgencyId");

            migrationBuilder.AddForeignKey(
                name: "FK_RouteTickets_Agencies_AgencyId",
                table: "RouteTickets",
                column: "AgencyId",
                principalTable: "Agencies",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_RouteTickets_Agencies_AgencyId",
                table: "RouteTickets");

            migrationBuilder.DropIndex(
                name: "IX_RouteTickets_AgencyId",
                table: "RouteTickets");

            migrationBuilder.DropColumn(
                name: "AgencyId",
                table: "RouteTickets");
        }
    }
}
