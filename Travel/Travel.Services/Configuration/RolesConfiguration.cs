using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Travel.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Services.Configuration;

namespace Travel.Services.Configuration
{
    public sealed class RolesConfiguration : IEntityTypeConfiguration<Role>
    {
        public void Configure(EntityTypeBuilder<Role> builder)
        {
            builder.Property(u => u.Name).IsRequired().HasMaxLength(100);
            builder.HasData(RolesSeed.Data);
        }
    }
}
