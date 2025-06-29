using Microsoft.EntityFrameworkCore;
using Travel.Services.Configuration;
using System.Data;
using Travel.Services.Configuration;
using Travel.Services.Interfaces;
namespace Travel.Services.Database
{
    public class AppDbContext : DbContext
    {
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
        public virtual DbSet<Notification> Notifications { get; set; }
        public virtual DbSet<Section> Sections { get; set; }
        public virtual DbSet<City> Cities { get; set; }
        public virtual DbSet<Agency> Agencies { get; set; }
        public virtual DbSet<Route> Routes { get; set; }
        public virtual DbSet<TripService> TripServices { get; set; }
        public virtual DbSet<OrganizedTrip> OrganizedTrips { get; set; }
        public virtual DbSet<RouteTicket> RouteTickets { get; set; }
        public virtual DbSet<TripTicket> TripTickets { get; set; }
        public virtual DbSet<SavedRoutes> SavedRoutes { get; set; }

        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {

        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);
            builder.ApplyConfiguration(new RolesConfiguration());
            builder.ApplyConfiguration(new UserConfiguration());;
            builder.ApplyConfiguration(new CityConfiguration());
            builder.ApplyConfiguration(new NotificationConfiguration());
            builder.ApplyConfiguration(new AgencyConfiguration());
            builder.ApplyConfiguration(new RouteConfiguration());
            builder.ApplyConfiguration(new TripServiceConfiguration());
            builder.ApplyConfiguration(new OrganizedTripServiceConfiguration());
            builder.ApplyConfiguration(new RouteTicketConfiguration());
            builder.ApplyConfiguration(new SavedRoutesConfiguration());
            
        }

        public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            ChangeTracker.DetectChanges();

            OnBeforeSaving();

            return await base.SaveChangesAsync(cancellationToken);
        }

        public override int SaveChanges()
        {
            ChangeTracker.DetectChanges();

            OnBeforeSaving();

            return base.SaveChanges();
        }

        private void OnBeforeSaving()
        {
            var updatedEntries = ChangeTracker
                .Entries()
                .Where(x => x.State != EntityState.Unchanged && x.State != EntityState.Detached && x.State != EntityState.Added);

            foreach (var entry in updatedEntries)
            {
                if (entry.State == EntityState.Deleted)
                {
                    if (entry.Entity is ISoftDelete deleteDate)
                    {
                        deleteDate.DeletedAt = DateTime.UtcNow;
                        entry.State = EntityState.Modified;
                    }
                }
                else
                {
                    if (entry.Entity is ITrackTimes updatedDate)
                    {
                        updatedDate.LastModified = DateTime.UtcNow;
                        entry.State = EntityState.Modified;
                    }
                }
            }

            var addedEntries = ChangeTracker
                .Entries()
                .Where(x => x.State == EntityState.Added);

            foreach (var entry in addedEntries)
            {
                if (entry.Entity is ITrackCreationTime creationTime)
                {
                    creationTime.CreatedAt = DateTime.UtcNow;
                }
            }
        }
    }
}
