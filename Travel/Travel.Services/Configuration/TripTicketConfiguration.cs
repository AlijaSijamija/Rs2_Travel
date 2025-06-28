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
    public sealed class TripTicketConfiguration : IEntityTypeConfiguration<TripTicket>
    {
        public void Configure(EntityTypeBuilder<TripTicket> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasQueryFilter(u => u.DeletedAt == null);
            builder.HasOne(n => n.Trip).WithMany(n => n.TripTickets).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(n => n.Passenger).WithMany(n => n.TripTickets).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(n => n.Agency).WithMany(n => n.TripTickets).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
