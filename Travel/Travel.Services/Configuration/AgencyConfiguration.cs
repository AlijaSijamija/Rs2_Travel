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
    public sealed class AgencyConfiguration : IEntityTypeConfiguration<Agency>
    {
        public void Configure(EntityTypeBuilder<Agency> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasQueryFilter(u => u.DeletedAt == null);
            builder.HasOne(n => n.Admin).WithMany(n => n.Agencies).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(n => n.City).WithMany(n => n.Agencies).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
