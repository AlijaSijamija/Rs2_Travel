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
    public sealed class AgencyAvailableBusesConfiguration : IEntityTypeConfiguration<AgencyAvailableBus>
    {
        public void Configure(EntityTypeBuilder<AgencyAvailableBus> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasQueryFilter(u => u.DeletedAt == null);
        }
    }
}
