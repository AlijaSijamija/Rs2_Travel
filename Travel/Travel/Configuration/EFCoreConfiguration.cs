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
            var user = new User
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
            result = userManager.CreateAsync(user).Result;
            roleResult = userManager.AddToRoleAsync(user, Roles.Passenger).Result;
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
    5, N'499196fe-d061-4d2b-8773-718c4fe431ea', NULL, CAST(N'2024-06-10T17:21:32.6523861' AS DateTime2), NULL, NULL, NULL);

SET IDENTITY_INSERT Agencies OFF;";

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



    }
}
