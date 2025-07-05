using Microsoft.EntityFrameworkCore;
using TravelDodatni.Database;

namespace TravelDodatni.Database
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<Notification> Notifications { get; set; }
        public virtual DbSet<Section> Sections { get; set; }
    }
}
