using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Services.Database;
using Travel.Services.Interfaces;

namespace Travel.Services.Services
{
    public class TripTicketService : BaseCRUDService<Models.TripTicket.TripTicket, Database.TripTicket, Models.Filters.BaseSearchObject, Models.TripTicket.TripTicketRequest, Models.TripTicket.TripTicketRequest, long>, ITripTicketService
    {
        public TripTicketService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override async Task BeforeInsert(Database.TripTicket entity, Models.TripTicket.TripTicketRequest insert)
        {
            var trip = _context.OrganizedTrips.FirstOrDefault(t => t.Id == insert.TripId);
            entity.AgencyId = trip.AgencyId;
            trip.AvailableSeats = trip.AvailableSeats - insert.NumberOfPassengers;
        }
    }
}
