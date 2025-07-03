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
    public sealed class ReadNotificationConfiguration : IEntityTypeConfiguration<ReadNotification>
    {
        public void Configure(EntityTypeBuilder<ReadNotification> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasQueryFilter(u => u.DeletedAt == null);
            builder.HasOne(n => n.Notification).WithMany(n => n.ReadNotifications).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(n => n.Passenger).WithMany(n => n.ReadNotifications).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
