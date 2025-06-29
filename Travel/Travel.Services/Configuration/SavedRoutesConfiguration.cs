using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Services.Database;

namespace Travel.Services.Configuration
{
    public sealed class SavedRoutesConfiguration : IEntityTypeConfiguration<SavedRoutes>
    {
        public void Configure(EntityTypeBuilder<SavedRoutes> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasOne(u => u.Passenger).WithMany(u => u.SavedRoutes).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(u => u.Route).WithMany(u => u.SavedRoutes).OnDelete(DeleteBehavior.NoAction);
            builder.HasQueryFilter(u => u.DeletedAt == null);
        }
    }
}
