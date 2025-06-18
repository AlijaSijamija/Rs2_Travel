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
    public sealed class OrganizedTripServiceConfiguration : IEntityTypeConfiguration<OrganizedTrip>
    {
        public void Configure(EntityTypeBuilder<OrganizedTrip> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasQueryFilter(u => u.DeletedAt == null);
            builder.HasOne(n => n.Agency).WithMany(n => n.Trips).OnDelete(DeleteBehavior.NoAction);
            builder.HasMany(n => n.IncludedServices).WithMany(n => n.Trips);
        }
    }
}
