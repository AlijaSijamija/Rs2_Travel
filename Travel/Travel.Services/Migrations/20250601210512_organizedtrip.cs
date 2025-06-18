using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Travel.Services.Migrations
{
    /// <inheritdoc />
    public partial class organizedtrip : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "OrganizedTrips",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TripName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Destination = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Price = table.Column<double>(type: "float", nullable: false),
                    AvailableSeats = table.Column<int>(type: "int", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AgencyId = table.Column<long>(type: "bigint", nullable: false),
                    ContactInfo = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedById = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                    LastModifiedBy = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LastModified = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OrganizedTrips", x => x.Id);
                    table.ForeignKey(
                        name: "FK_OrganizedTrips_Agencies_AgencyId",
                        column: x => x.AgencyId,
                        principalTable: "Agencies",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "TripServices",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedById = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                    LastModifiedBy = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LastModified = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TripServices", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "OrganizedTripTripService",
                columns: table => new
                {
                    IncludedServicesId = table.Column<long>(type: "bigint", nullable: false),
                    TripsId = table.Column<long>(type: "bigint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OrganizedTripTripService", x => new { x.IncludedServicesId, x.TripsId });
                    table.ForeignKey(
                        name: "FK_OrganizedTripTripService_OrganizedTrips_TripsId",
                        column: x => x.TripsId,
                        principalTable: "OrganizedTrips",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_OrganizedTripTripService_TripServices_IncludedServicesId",
                        column: x => x.IncludedServicesId,
                        principalTable: "TripServices",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_OrganizedTrips_AgencyId",
                table: "OrganizedTrips",
                column: "AgencyId");

            migrationBuilder.CreateIndex(
                name: "IX_OrganizedTripTripService_TripsId",
                table: "OrganizedTripTripService",
                column: "TripsId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "OrganizedTripTripService");

            migrationBuilder.DropTable(
                name: "OrganizedTrips");

            migrationBuilder.DropTable(
                name: "TripServices");
        }
    }
}
