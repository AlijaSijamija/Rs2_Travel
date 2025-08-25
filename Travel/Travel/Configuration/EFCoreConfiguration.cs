using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Travel.Models.Enums;
using Travel.Services.Database;

namespace Travel.Configuration
{
    public static class EFCoreConfiguration
    {
        public static void AddEFCoreInfrastructure(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddDbContext<AppDbContext>(options =>
                options.UseSqlServer(configuration.GetConnectionString("DefaultConnection"),
                b => b.MigrationsAssembly(typeof(AppDbContext).Assembly.FullName))
            );
        }

        public static void SeedData(this IApplicationBuilder app)
        {
            using (var serviceScope = app.ApplicationServices.GetRequiredService<IServiceScopeFactory>().CreateScope())
            {
                var context = serviceScope.ServiceProvider.GetService<AppDbContext>();
                context.Database.SetCommandTimeout(TimeSpan.FromMinutes(3));
                context.Database.Migrate();

                if (!context.Cities.Any())
                {
                    SeedCitiesCategories(context);
                }

                if (!context.Users.Any())
                {
                    SeedUsers(context, serviceScope);
                }


                if (!context.Sections.Any())
                {
                    SeedSections(context);
                }

                if (!context.Notifications.Any())
                {
                    SeedNotifications(context);
                }

                if (!context.Agencies.Any())
                {
                    SeedAgencies(context);
                }

                if (!context.TripServices.Any())
                {
                    SeedTripService(context);
                }

                if (!context.OrganizedTrips.Any())
                {
                    SeedOrganizedTrips(context);
                    SeedOrganizedTripServices(context);
                    SeedTripTickets(context);
                }

                if (!context.Routes.Any())
                {
                    SeedRoutesAndSavedRoutes(context);
                    SeedRouteTickets(context);
                }

                if (!context.AgencyAvailableBuses.Any())
                {
                    SeedAgencyAvailableBuses(context);
                }
            }
        }

        private static void SeedUsers(AppDbContext context, IServiceScope scope)
        {
            var userManager = scope.ServiceProvider.GetService<UserManager<User>>();

            var admin = new User
            {
                Id = "499196fe-d061-4d2b-8773-718c4fe431ea",
                Username = "test@admin.com",
                Email = "test@admin.com",
                FirstName = "Test",
                LastName = "Admin",
                BirthDate = DateTime.Parse("2024-06-01T12:52:21.5160000"),
                Gender = Gender.Male,
                PhoneNumber = "123456",
                PasswordHash = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SecurityStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = false,
                CreatedById = null,
                CreatedAt = DateTime.Parse("2024-06-01T13:03:09.9051960"),
                LastModifiedBy = null,
                LastModified = DateTime.Parse("2024-06-01T13:03:15.7230865"),
                DeletedAt = null,
                CityId = null,
            };
            var result = userManager.CreateAsync(admin).Result;
            var roleResult = userManager.AddToRoleAsync(admin, Roles.Admin).Result;

            var passenger1 = new User
            {
                Id = "657dbebe-f4e7-43c0-99a1-487798b54c48",
                Username = "test@passenger.com",
                Email = "test@passenger.com",
                FirstName = "Test",
                LastName = "Passenger",
                BirthDate = DateTime.Parse("2024-06-11"),
                Gender = Gender.Female,
                PhoneNumber = "123456",
                PasswordHash = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SecurityStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = false,
                CreatedById = null,
                CreatedAt = DateTime.Parse("2024-06-11T11:33:52.6011618"),
                LastModifiedBy = null,
                LastModified = DateTime.Parse("2024-06-11T11:33:52.8975394"),
                DeletedAt = null,
                CityId = 2,
            };
            result = userManager.CreateAsync(passenger1).Result;
            roleResult = userManager.AddToRoleAsync(passenger1, Roles.Passenger).Result;

            var passenger2 = new User
            {
                Id = "f1a26e35-3be3-476b-a91b-2100b8adcb01",
                Username = "passenger2@demo.com",
                Email = "passenger2@demo.com",
                FirstName = "Demo",
                LastName = "Passenger2",
                BirthDate = DateTime.Parse("1995-04-15"),
                Gender = Gender.Male,
                PhoneNumber = "061000002",
                PasswordHash = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SecurityStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                CreatedAt = DateTime.Now,
                CityId = 4
            };
            result = userManager.CreateAsync(passenger2).Result;
            roleResult = userManager.AddToRoleAsync(passenger2, Roles.Passenger).Result;

            var passenger3 = new User
            {
                Id = "c7e55bcb-1f68-4f0a-9110-0adf1ec6e881",
                Username = "passenger3@demo.com",
                Email = "passenger3@demo.com",
                FirstName = "Demo",
                LastName = "Passenger3",
                BirthDate = DateTime.Parse("1992-10-22"),
                Gender = Gender.Female,
                PhoneNumber = "061000003",
                PasswordHash = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SecurityStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                CreatedAt = DateTime.Now,
                CityId = 4
            };
            result = userManager.CreateAsync(passenger3).Result;
            roleResult = userManager.AddToRoleAsync(passenger3, Roles.Passenger).Result;

            var passenger4 = new User
            {
                Id = "abc72a10-8e6e-4536-91cd-d96c9fd19e50",
                Username = "passenger4@demo.com",
                Email = "passenger4@demo.com",
                FirstName = "Demo",
                LastName = "Passenger4",
                BirthDate = DateTime.Parse("1998-12-05"),
                Gender = Gender.Male,
                PhoneNumber = "061000004",
                PasswordHash = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SecurityStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                CreatedAt = DateTime.Now,
                CityId = 5
            };
            result = userManager.CreateAsync(passenger4).Result;
            roleResult = userManager.AddToRoleAsync(passenger4, Roles.Passenger).Result;

            var passenger5 = new User
            {
                Id = "dd734edf-9d0c-4b8c-9c99-451c2e8619a2",
                Username = "passenger5@demo.com",
                Email = "passenger5@demo.com",
                FirstName = "Demo",
                LastName = "Passenger5",
                BirthDate = DateTime.Parse("1990-08-09"),
                Gender = Gender.Male,
                PhoneNumber = "061000005",
                PasswordHash = "AQAAAAEAACcQAAAAEI3BSc0gbecYS0n/u7kn4aJCrTeXPGySz/wMzHi3gdN57pibjJ3i406RXptP4H2DBA==",
                SecurityStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                CreatedAt = DateTime.Now,
                CityId = 1
            };
            result = userManager.CreateAsync(passenger5).Result;
            roleResult = userManager.AddToRoleAsync(passenger5, Roles.Passenger).Result;
        }

        private static void SeedCitiesCategories(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Cities ON;

    INSERT INTO Cities (Id, Name, CreatedById, CreatedAt) VALUES
    (1, 'Mostar', NULL, '2024-06-08T00:00:00.0000000'),
    (2, 'Bugojno', NULL, '2024-06-10T00:00:00.0000000'),
    (4, 'Sarajevo', NULL, '2024-06-10T00:00:00.0000000'),
    (5, 'Zenica', NULL, '2024-06-10T00:00:00.0000000'),
    (6, 'Livno', NULL, '2024-06-10T00:00:00.0000000'),
    (7, 'Donji Vakuf', NULL, '2024-06-10T00:00:00.0000000');

    SET IDENTITY_INSERT Cities OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedSections(AppDbContext context)
        {
            var sqlCommand = @"
SET IDENTITY_INSERT Sections ON;

INSERT INTO Sections (Id, Name, CreatedById, CreatedAt, LastModifiedBy, LastModified) VALUES
(1, N'Trip Reminder', NULL, CAST(N'2024-06-10T00:00:00.0000000' AS DateTime2), NULL, NULL),
(3, N'Travel Training Session', NULL, CAST(N'2024-06-10T00:00:00.0000000' AS DateTime2), NULL, NULL),
(4, N'Trip Details Updated', NULL, CAST(N'2024-06-10T00:00:00.0000000' AS DateTime2), NULL, NULL),
(5, N'Upcoming Passenger Orientation', NULL, CAST(N'2024-06-10T00:00:00.0000000' AS DateTime2), NULL, NULL),
(6, N'Trip Booking Confirmation', NULL, CAST(N'2024-06-10T00:00:00.0000000' AS DateTime2), NULL, NULL);

SET IDENTITY_INSERT Sections OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }
        private static void SeedNotifications(AppDbContext context)
        {
            var sqlCommand = @"
SET IDENTITY_INSERT Notifications ON;

INSERT INTO Notifications (Id, Heading, Content, SectionId, AdminId, CreatedById, CreatedAt, LastModifiedBy, LastModified, DeletedAt) VALUES
(1, N'Passenger Welcome Session', 
    N'You are invited to our welcome session for new passengers on Monday, June 12th at 5:00 PM. Learn how to use the eTravel system, plan your trips efficiently, and get support from our travel assistants.', 
    5, N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, CAST(N'2024-06-10T17:21:32.6523861' AS DateTime2), NULL, NULL, NULL),

(2, N'Travel Reservation Confirmed', 
    N'Your seat reservation for the City Express route on Saturday, June 14th has been confirmed. Please arrive 10 minutes early and bring your digital ticket for a smooth check-in experience.', 
    6, N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, CAST(N'2024-06-10T17:22:33.9782992' AS DateTime2), NULL, NULL, NULL);

SET IDENTITY_INSERT Notifications OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedAgencies(AppDbContext context)
        {
            var sqlCommand = @"
SET IDENTITY_INSERT Agencies ON;

INSERT INTO Agencies (Id, Name, Web, Contact, CityId, AdminId, CreatedById, CreatedAt, LastModifiedBy, LastModified, DeletedAt) VALUES
(1, N'Eme tours', 
    N'www.google.com', N'+38762111111', 
    5, N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, CAST(N'2024-06-10T17:21:32.6523861' AS DateTime2), NULL, NULL, NULL),
(2, N'Centrotrans', 
    N'www.youtube.com', N'+38762111111', 
    5, N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, CAST(N'2024-06-10T17:21:32.6523861' AS DateTime2), NULL, NULL, NULL),
(3, N'Balkan Express', 
    N'www.balkanexpress.com', N'+38762222333', 
    4, N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, GETDATE(), NULL, NULL, NULL),
(4, N'Travel4You', 
    N'www.travel4you.ba', N'+38762333444', 
    6, N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, GETDATE(), NULL, NULL, NULL),
(5, N'Eurobus', 
    N'www.eurobus.eu', N'+38762444555', 
    7, N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, GETDATE(), NULL, NULL, NULL),
(6, N'Adria Travel', 
    N'www.adriatravel.hr', N'+38598111222', 
    7, N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, GETDATE(), NULL, NULL, NULL),
(7, N'Global Adventures', 
    N'www.globaladv.com', N'+38762555666', 
    6, N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, GETDATE(), NULL, NULL, NULL);

SET IDENTITY_INSERT Agencies OFF;
";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }


        private static void SeedTripService(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT TripServices ON;

    INSERT INTO TripServices (Id, Name, CreatedById, CreatedAt) VALUES
    (1, 'Accommodation', NULL, '2024-06-01T00:00:00.0000000'),
    (2, 'Transportation', NULL, '2024-06-01T00:00:00.0000000'),
    (3, 'Breakfast', NULL, '2024-06-01T00:00:00.0000000'),
    (4, 'Tour Guide', NULL, '2024-06-01T00:00:00.0000000'),
    (5, 'Travel Insurance', NULL, '2024-06-01T00:00:00.0000000');

    SET IDENTITY_INSERT TripServices OFF;";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedOrganizedTrips(AppDbContext context)
        {
            var sqlCommand = @"
SET IDENTITY_INSERT OrganizedTrips ON;

INSERT INTO OrganizedTrips 
(Id, TripName, Destination, StartDate, EndDate, Price, AvailableSeats, NumberOfSeats, Description, AgencyId, ContactInfo, CreatedById, CreatedAt, LastModifiedBy, LastModified, DeletedAt) 
VALUES
(1, N'Summer Escape to Dubrovnik', N'Dubrovnik', '2025-07-20', '2025-07-25', 299.99, 12, 30, 
 N'Enjoy a guided summer trip to the Croatian coast with beaches, city tours, and local cuisine.', 
 1, N'info@travelcoast.hr | +385-21-123-456', NULL, GETDATE(), NULL, NULL, NULL),

(2, N'Weekend in Sarajevo', N'Sarajevo', '2025-08-10', '2025-08-12', 149.00, 20, 25, 
 N'A cultural weekend exploring Sarajevo''s history, food, and nightlife.', 
 2, N'contact@balkantravel.ba | +387-33-123-789', NULL, GETDATE(), NULL, NULL, NULL),

(3, N'Adventure in the Alps', N'Slovenian Alps', '2025-09-01', '2025-09-07', 450.50, 8, 15, 
 N'Join us for hiking, rafting and exploring Slovenia''s stunning alpine region.', 
 3, N'office@mountainfun.si | +386-40-987-321', NULL, GETDATE(), NULL, NULL, NULL),

(4, N'Budapest City Lights', N'Budapest', '2025-10-05', '2025-10-08', 210.00, 10, 20, 
 N'Discover Hungary''s capital with thermal spas, river cruises, and food tasting.', 
 1, N'support@eutravel.hu | +36-1-234-5678', NULL, GETDATE(), NULL, NULL, NULL),

(5, N'Vienna Classical Tour', N'Vienna', '2025-09-15', '2025-09-18', 230.00, 5, 20, 
 N'A trip through Vienna''s imperial history with music concerts and palaces.', 
 2, N'info@viennatrips.at | +43-1-765-4321', NULL, GETDATE(), NULL, NULL, NULL),

(6, N'Zlatibor Autumn Retreat', N'Zlatibor', '2025-10-20', '2025-10-25', 180.00, 16, 25, 
 N'Breathe the mountain air and relax in Serbia''s top nature getaway.', 
 3, N'reservations@relaxbalkan.rs | +381-11-123-4567', NULL, GETDATE(), NULL, NULL, NULL),

(7, N'Weekend in Mostar', N'Mostar', '2025-08-22', '2025-08-24', 99.99, 9, 15, 
 N'Explore Old Bridge, river walks, and local cuisine in Mostar.', 
 1, N'mostar@travel.ba | +387-36-222-555', NULL, GETDATE(), NULL, NULL, NULL),

(8, N'Munich Oktoberfest Tour', N'Munich', '2025-09-28', '2025-10-03', 380.00, 7, 20, 
 N'Experience Germany''s Oktoberfest with guided beer hall visits and sightseeing.', 
 2, N'oktober@festtrips.de | +49-89-123-9876', NULL, GETDATE(), NULL, NULL, NULL),

(9, N'Kotor Bay Getaway', N'Kotor', '2025-07-29', '2025-08-02', 270.00, 14, 25, 
 N'Relax in the coastal town of Kotor with boat trips and old town walks.', 
 3, N'kotor@coast.me | +382-32-888-123', NULL, GETDATE(), NULL, NULL, NULL),

(10, N'Plitvice Lakes Day Trip', N'Plitvice Lakes', '2025-08-05', '2025-08-05', 85.00, 18, 20, 
 N'Day excursion to Croatia''s famous national park with waterfalls and lakes.', 
 1, N'plitvice@greenroutes.hr | +385-53-555-321', NULL, GETDATE(), NULL, NULL, NULL);

SET IDENTITY_INSERT OrganizedTrips OFF;
";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedOrganizedTripServices(AppDbContext context)
        {
            var services = context.TripServices.ToList();
            var trips = context.OrganizedTrips.ToList();
            TripService GetService(string name) => services.First(s => s.Name == name);

            foreach (var trip in trips)
            {
                switch (trip.Id)
                {
                    case 1:
                        trip.IncludedServices.Add(GetService("Accommodation"));
                        trip.IncludedServices.Add(GetService("Transportation"));
                        trip.IncludedServices.Add(GetService("Breakfast"));
                        trip.IncludedServices.Add(GetService("Tour Guide"));
                        break;
                    case 2:
                        trip.IncludedServices.Add(GetService("Accommodation"));
                        trip.IncludedServices.Add(GetService("Transportation"));
                        trip.IncludedServices.Add(GetService("Breakfast"));
                        break;
                    case 3:
                        trip.IncludedServices.Add(GetService("Accommodation"));
                        trip.IncludedServices.Add(GetService("Transportation"));
                        trip.IncludedServices.Add(GetService("Tour Guide"));
                        trip.IncludedServices.Add(GetService("Travel Insurance"));
                        break;
                    case 4:
                        trip.IncludedServices.Add(GetService("Accommodation"));
                        trip.IncludedServices.Add(GetService("Transportation"));
                        trip.IncludedServices.Add(GetService("Tour Guide"));
                        break;
                    case 5:
                        trip.IncludedServices.Add(GetService("Accommodation"));
                        trip.IncludedServices.Add(GetService("Transportation"));
                        trip.IncludedServices.Add(GetService("Breakfast"));
                        trip.IncludedServices.Add(GetService("Travel Insurance"));
                        break;
                    case 6:
                        trip.IncludedServices.Add(GetService("Accommodation"));
                        trip.IncludedServices.Add(GetService("Breakfast"));
                        trip.IncludedServices.Add(GetService("Travel Insurance"));
                        break;
                    case 7:
                        trip.IncludedServices.Add(GetService("Accommodation"));
                        trip.IncludedServices.Add(GetService("Transportation"));
                        break;
                    case 8:
                        trip.IncludedServices.Add(GetService("Transportation"));
                        trip.IncludedServices.Add(GetService("Breakfast"));
                        trip.IncludedServices.Add(GetService("Tour Guide"));
                        trip.IncludedServices.Add(GetService("Travel Insurance"));
                        break;
                    case 9:
                        trip.IncludedServices.Add(GetService("Accommodation"));
                        trip.IncludedServices.Add(GetService("Transportation"));
                        trip.IncludedServices.Add(GetService("Travel Insurance"));
                        break;
                    case 10:
                        trip.IncludedServices.Add(GetService("Transportation"));
                        trip.IncludedServices.Add(GetService("Tour Guide"));
                        break;
                }
            }

            context.SaveChanges();
        }

        private static void SeedTripTickets(AppDbContext context)
        {
            var passengerId = "657dbebe-f4e7-43c0-99a1-487798b54c48";

            var trips = context.OrganizedTrips.Where(t => new[] { 1L, 2L, 3L, 4L }.Contains(t.Id)).ToList();
            var agencies = context.Agencies.ToList();

            if (!trips.Any() || !agencies.Any())
                return;

            var tickets = new List<TripTicket>
    {
        new TripTicket
        {
            PassengerId = passengerId,
            Price = 199.99,
            TripId = 1,
            AgencyId = 1,
            NumberOfPassengers = 2,
            CreatedAt = DateTime.Now,
            CreatedById = null,
            LastModified = DateTime.Now,
            TicketSeats = new List<TicketSeat>
            {
                new TicketSeat { SeatNumber = "1A", PassengerName = "Test Passenger", CreatedAt = DateTime.Now, LastModified = DateTime.Now },
                new TicketSeat { SeatNumber = "2A", PassengerName = "Guest Passenger", CreatedAt = DateTime.Now, LastModified = DateTime.Now }
            }
        },
        new TripTicket // passed trip
        {
            PassengerId = passengerId,
            Price = 150.00,
            TripId = 2,
            AgencyId = 2,
            NumberOfPassengers = 1,
            CreatedAt = new DateTime(2024, 6, 10),
            CreatedById = null,
            LastModified = DateTime.Now,
            TicketSeats = new List<TicketSeat>
            {
                new TicketSeat { SeatNumber = "3A", PassengerName = "Old Trip Passenger", CreatedAt = DateTime.Now, LastModified = DateTime.Now }
            }
        },
        new TripTicket
        {
            PassengerId = passengerId,
            Price = 220.00,
            TripId = 3,
            AgencyId = 3,
            NumberOfPassengers = 3,
            CreatedAt = DateTime.Now,
            CreatedById = null,
            LastModified = DateTime.Now,
            TicketSeats = new List<TicketSeat>
            {
                new TicketSeat { SeatNumber = "4A", PassengerName = "Passenger 1", CreatedAt = DateTime.Now, LastModified = DateTime.Now },
                new TicketSeat { SeatNumber = "5B", PassengerName = "Passenger 2", CreatedAt = DateTime.Now, LastModified = DateTime.Now },
                new TicketSeat { SeatNumber = "6B", PassengerName = "Passenger 3", CreatedAt = DateTime.Now, LastModified = DateTime.Now }
            }
        },
        new TripTicket
        {
            PassengerId = passengerId,
            Price = 180.50,
            TripId = 4,
            AgencyId = 4,
            NumberOfPassengers = 1,
            CreatedAt = DateTime.Now,
            CreatedById = null,
            LastModified = DateTime.Now,
            TicketSeats = new List<TicketSeat>
            {
                new TicketSeat { SeatNumber = "5A", PassengerName = "Solo Passenger", CreatedAt = DateTime.Now, LastModified = DateTime.Now }
            }
        }
    };

            var extraPassengerIds = new[]
{
    "f1a26e35-3be3-476b-a91b-2100b8adcb01",
    "c7e55bcb-1f68-4f0a-9110-0adf1ec6e881",
    "dd734edf-9d0c-4b8c-9c99-451c2e8619a2",
    "abc72a10-8e6e-4536-91cd-d96c9fd19e50"
};

            int seatCounter = 7;

            foreach (var id in extraPassengerIds)
            {
                tickets.Add(new TripTicket
                {
                    PassengerId = id,
                    Price = 199.99,
                    TripId = 1,
                    AgencyId = 1,
                    NumberOfPassengers = 1,
                    CreatedAt = DateTime.Now,
                    CreatedById = null,
                    LastModified = DateTime.Now,
                    TicketSeats = new List<TicketSeat>
        {
            new TicketSeat
            {
                SeatNumber = $"{seatCounter++}A",
                PassengerName = "Auto Seed Passenger",
                CreatedAt = DateTime.Now,
                LastModified = DateTime.Now
            }
        }
                });
            }


            context.TripTickets.AddRange(tickets);
            context.SaveChanges();
        }



        private static void SeedRoutesAndSavedRoutes(AppDbContext context)
        {
            var sqlRoutes = @"
SET IDENTITY_INSERT Routes ON;

INSERT INTO Routes 
(Id, NumberOfSeats, AvailableSeats, AdultPrice, ChildPrice, FromCityId, ToCityId, TravelTime, 
 DepartureTime, ArrivalTime, ValidFrom, ValidTo, AgencyId, BusType, CreatedById, CreatedAt, LastModifiedBy, LastModified, DeletedAt) 
VALUES
(1, 50, 45, 25.00, 15.00, 1, 2, '2h 30m', '08:00:00', '10:30:00', '2024-07-01', '2025-12-31', 1, 2, NULL, GETDATE(), NULL, NULL, NULL),
(2, 40, 20, 30.00, 18.00, 7, 5, '4h 00m', '10:00:00', '14:00:00', '2024-07-10', '2025-11-30', 2, 2, NULL, GETDATE(), NULL, NULL, NULL),
(3, 60, 60, 20.00, 10.00, 2, 4, '1h 45m', '06:30:00', '08:15:00', '2024-08-01', '2025-10-15', 3, 3, NULL, GETDATE(), NULL, NULL, NULL),
(4, 55, 10, 50.00, 35.00, 5, 1, '3h 20m', '14:00:00', '17:20:00', '2024-07-20', '2025-09-30', 4, 3, NULL, GETDATE(), NULL, NULL, NULL),
(5, 30, 5, 45.00, 25.00, 4, 6, '5h 10m', '07:00:00', '12:10:00', '2024-07-15', '2025-08-31', 5, 1, NULL, GETDATE(), NULL, NULL, NULL);

SET IDENTITY_INSERT Routes OFF;
";

            context.Database.ExecuteSqlRaw(sqlRoutes);

            var sqlSavedRoutes = @"
SET IDENTITY_INSERT SavedRoutes ON;

INSERT INTO SavedRoutes 
(Id, PassengerId, RouteId, ValidFrom, ValidTo, CreatedById, CreatedAt, LastModifiedBy, LastModified, DeletedAt) 
VALUES
(1, '657dbebe-f4e7-43c0-99a1-487798b54c48', 1, '2024-07-01', '2025-07-10', NULL, GETDATE(), NULL, NULL, NULL),
(2, '657dbebe-f4e7-43c0-99a1-487798b54c48', 3, '2024-08-01', '2025-08-10', NULL, GETDATE(), NULL, NULL, NULL),
(3, '657dbebe-f4e7-43c0-99a1-487798b54c48', 5, '2024-07-15', '2025-07-25', NULL, GETDATE(), NULL, NULL, NULL);

SET IDENTITY_INSERT SavedRoutes OFF;
";

            context.Database.ExecuteSqlRaw(sqlSavedRoutes);
        }

        private static void SeedRouteTickets(AppDbContext context)
        {
            var passengerId = "657dbebe-f4e7-43c0-99a1-487798b54c48";

            var routes = context.Routes.Where(r => new[] { 1L, 2L, 3L, 4L, 5L }.Contains(r.Id)).ToList();
            var agencies = context.Agencies.ToList();

            if (!routes.Any() || !agencies.Any()) return;

            var tickets = new List<RouteTicket>
    {
        new RouteTicket
        {
            PassengerId = passengerId,
            Price = 40.0,
            RouteId = 1,
            AgencyId = 1,
            NumberOfAdultPassengers = 1,
            NumberOfChildPassengers = 1,
            DepartureDate = new DateTime(2025, 7, 15, 8, 0, 0),
            ArrivalDate = new DateTime(2025, 7, 15, 10, 30, 0),
            CreatedAt = DateTime.Now,
            LastModified = DateTime.Now,
            TicketSeats = new List<TicketSeat>
            {
                new TicketSeat { SeatNumber = "1A", PassengerName = "Test Passenger", CreatedAt = DateTime.Now, LastModified = DateTime.Now },
                new TicketSeat { SeatNumber = "2A", PassengerName = "Child Passenger", CreatedAt = DateTime.Now, LastModified = DateTime.Now }
            }
        },
        new RouteTicket // passed
        {
            PassengerId = passengerId,
            Price = 30.0,
            RouteId = 2,
            AgencyId = 2,
            NumberOfAdultPassengers = 1,
            NumberOfChildPassengers = 0,
            DepartureDate = new DateTime(2024, 7, 15, 10, 0, 0),
            ArrivalDate = new DateTime(2024, 7, 15, 14, 0, 0),
            CreatedAt = DateTime.Now,
            LastModified = DateTime.Now,
            TicketSeats = new List<TicketSeat>
            {
                new TicketSeat { SeatNumber = "3A", PassengerName = "Test Passenger", CreatedAt = DateTime.Now, LastModified = DateTime.Now }
            }
        },
        new RouteTicket
        {
            PassengerId = passengerId,
            Price = 20.0,
            RouteId = 3,
            AgencyId = 3,
            NumberOfAdultPassengers = 2,
            NumberOfChildPassengers = 1,
            DepartureDate = new DateTime(2025, 9, 10, 6, 30, 0),
            ArrivalDate = new DateTime(2025, 9, 10, 8, 15, 0),
            CreatedAt = DateTime.Now,
            LastModified = DateTime.Now,
            TicketSeats = new List<TicketSeat>
            {
                new TicketSeat { SeatNumber = "4A", PassengerName = "Passenger 1", CreatedAt = DateTime.Now, LastModified = DateTime.Now },
                new TicketSeat { SeatNumber = "5B", PassengerName = "Passenger 2", CreatedAt = DateTime.Now, LastModified = DateTime.Now },
                new TicketSeat { SeatNumber = "6B", PassengerName = "Child Passenger", CreatedAt = DateTime.Now, LastModified = DateTime.Now }
            }
        },
        new RouteTicket // passed
        {
            PassengerId = passengerId,
            Price = 45.0,
            RouteId = 5,
            AgencyId = 5,
            NumberOfAdultPassengers = 1,
            NumberOfChildPassengers = 0,
            DepartureDate = new DateTime(2024, 7, 20, 7, 0, 0),
            ArrivalDate = new DateTime(2024, 7, 20, 12, 10, 0),
            CreatedAt = DateTime.Now,
            LastModified = DateTime.Now,
            TicketSeats = new List<TicketSeat>
            {
                new TicketSeat { SeatNumber = "7B", PassengerName = "Test Passenger", CreatedAt = DateTime.Now, LastModified = DateTime.Now }
            }
        },
        new RouteTicket
        {
            PassengerId = passengerId,
            Price = 50.0,
            RouteId = 4,
            AgencyId = 4,
            NumberOfAdultPassengers = 1,
            NumberOfChildPassengers = 1,
            DepartureDate = new DateTime(2025, 8, 5, 14, 0, 0),
            ArrivalDate = new DateTime(2025, 8, 5, 17, 20, 0),
            CreatedAt = DateTime.Now,
            LastModified = DateTime.Now,
            TicketSeats = new List<TicketSeat>
            {
                new TicketSeat { SeatNumber = "9C", PassengerName = "Adult Passenger", CreatedAt = DateTime.Now, LastModified = DateTime.Now },
                new TicketSeat { SeatNumber = "10C", PassengerName = "Child Passenger", CreatedAt = DateTime.Now, LastModified = DateTime.Now }
            }
        }


    };
            var extraPassengerIds = new[]
{
    "f1a26e35-3be3-476b-a91b-2100b8adcb01",
    "c7e55bcb-1f68-4f0a-9110-0adf1ec6e881",
    "dd734edf-9d0c-4b8c-9c99-451c2e8619a2",
    "abc72a10-8e6e-4536-91cd-d96c9fd19e50"
};

            int seatCounter = 11;
            var departure = new DateTime(2025, 7, 25, 9, 0, 0);
            var arrival = new DateTime(2025, 7, 25, 12, 0, 0);

            foreach (var id in extraPassengerIds)
            {
                tickets.Add(new RouteTicket
                {
                    PassengerId = id,
                    Price = 35.0,
                    RouteId = 1,
                    AgencyId = 1,
                    NumberOfAdultPassengers = 1,
                    NumberOfChildPassengers = 0,
                    DepartureDate = departure,
                    ArrivalDate = arrival,
                    CreatedAt = DateTime.Now,
                    LastModified = DateTime.Now,
                    TicketSeats = new List<TicketSeat>
        {
            new TicketSeat
            {
                SeatNumber = $"{seatCounter++}A",
                PassengerName = "Auto Seed Passenger",
                CreatedAt = DateTime.Now,
                LastModified = DateTime.Now
            }
        }
                });
            }

            context.RouteTickets.AddRange(tickets);
            context.SaveChanges();
        }

        private static void SeedAgencyAvailableBuses(AppDbContext context)
        {
            var agencies = context.Agencies.ToList();

            if (!agencies.Any())
                return;

            var availablebuses = new List<AgencyAvailableBus>
            {
                new AgencyAvailableBus
                {
                    AgencyId = 1,
                    BusType = BusType.Midi,
                    CreatedAt = DateTime.Now,
                    CreatedById = null,
                    LastModified = DateTime.Now,
                },
                 new AgencyAvailableBus
                {
                    AgencyId = 1,
                    BusType = BusType.Luxury,
                    CreatedAt = DateTime.Now,
                    CreatedById = null,
                    LastModified = DateTime.Now,
                },
                new AgencyAvailableBus
                {
                    AgencyId = 2,
                    BusType = BusType.Midi,
                    CreatedAt = DateTime.Now,
                    CreatedById = null,
                    LastModified = DateTime.Now,
                },
                 new AgencyAvailableBus
                {
                    AgencyId = 2,
                    BusType = BusType.Standard,
                    CreatedAt = DateTime.Now,
                    CreatedById = null,
                    LastModified = DateTime.Now,
                },
                  new AgencyAvailableBus
                {
                    AgencyId = 3,
                    BusType = BusType.Midi,
                    CreatedAt = DateTime.Now,
                    CreatedById = null,
                    LastModified = DateTime.Now,
                },
                new AgencyAvailableBus
                {
                    AgencyId = 3,
                    BusType = BusType.Standard,
                    CreatedAt = DateTime.Now,
                    CreatedById = null,
                    LastModified = DateTime.Now,
                },
                 new AgencyAvailableBus
                {
                    AgencyId = 3,
                    BusType = BusType.Luxury,
                    CreatedAt = DateTime.Now,
                    CreatedById = null,
                    LastModified = DateTime.Now,
                },
                 new AgencyAvailableBus
                {
                    AgencyId = 4,
                    BusType = BusType.Standard,
                    CreatedAt = DateTime.Now,
                    CreatedById = null,
                    LastModified = DateTime.Now,
                },
                  new AgencyAvailableBus
                {
                    AgencyId = 5,
                    BusType = BusType.Mini,
                    CreatedAt = DateTime.Now,
                    CreatedById = null,
                    LastModified = DateTime.Now,
                },
                   new AgencyAvailableBus
                {
                    AgencyId = 6,
                    BusType = BusType.Mini,
                    CreatedAt = DateTime.Now,
                    CreatedById = null,
                    LastModified = DateTime.Now,
                },
                    new AgencyAvailableBus
                {
                    AgencyId = 7,
                    BusType = BusType.Mini,
                    CreatedAt = DateTime.Now,
                    CreatedById = null,
                    LastModified = DateTime.Now,
                }
            };
            context.AgencyAvailableBuses.AddRange(availablebuses);
            context.SaveChanges();
        }
    }
}
