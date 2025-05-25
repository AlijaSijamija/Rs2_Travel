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
    public sealed class RouteConfiguration : IEntityTypeConfiguration<Route>
    {
        public void Configure(EntityTypeBuilder<Route> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasQueryFilter(u => u.DeletedAt == null);
            builder.HasOne(n => n.Agency).WithMany(n => n.Routes).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(n => n.ToCity).WithMany(n => n.ToRoutes).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(n => n.FromCity).WithMany(n => n.FromRoutes).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
