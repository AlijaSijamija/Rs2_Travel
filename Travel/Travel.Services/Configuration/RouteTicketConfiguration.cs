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
    public sealed class RouteTicketConfiguration : IEntityTypeConfiguration<RouteTicket>
    {
        public void Configure(EntityTypeBuilder<RouteTicket> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(w => w.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            builder.HasQueryFilter(u => u.DeletedAt == null);
            builder.HasOne(n => n.Route).WithMany(n => n.RouteTickets).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(n => n.Passenger).WithMany(n => n.RouteTickets).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(n => n.Agency).WithMany(n => n.RouteTickets).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
