using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Travel.Services.Migrations
{
    /// <inheritdoc />
    public partial class TicketSeat : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "TicketSeats",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TripTicketId = table.Column<long>(type: "bigint", nullable: true),
                    RouteTicketId = table.Column<long>(type: "bigint", nullable: true),
                    SeatNumber = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PassengerName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedById = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                    LastModifiedBy = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LastModified = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TicketSeats", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TicketSeats_RouteTickets_RouteTicketId",
                        column: x => x.RouteTicketId,
                        principalTable: "RouteTickets",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_TicketSeats_TripTickets_TripTicketId",
                        column: x => x.TripTicketId,
                        principalTable: "TripTickets",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_TicketSeats_RouteTicketId",
                table: "TicketSeats",
                column: "RouteTicketId");

            migrationBuilder.CreateIndex(
                name: "IX_TicketSeats_TripTicketId",
                table: "TicketSeats",
                column: "TripTicketId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "TicketSeats");
        }
    }
}
