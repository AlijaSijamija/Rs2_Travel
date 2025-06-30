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
    public sealed class TicketSeatConfiguration : IEntityTypeConfiguration<TicketSeat>
    {
        public void Configure(EntityTypeBuilder<TicketSeat> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasOne(u => u.RouteTicket).WithMany(u => u.TicketSeats).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(u => u.TripTicket).WithMany(u => u.TicketSeats).OnDelete(DeleteBehavior.NoAction);
            builder.HasQueryFilter(u => u.DeletedAt == null);
        }
    }
}
