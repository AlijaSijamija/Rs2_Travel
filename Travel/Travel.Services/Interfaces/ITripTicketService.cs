using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Filters;
using Travel.Models.TripTicket;

namespace Travel.Services.Interfaces
{
    public interface ITripTicketService :ICRUDService<Models.TripTicket.TripTicket, BaseSearchObject, TripTicketRequest, TripTicketRequest, long>
    {
        List<Models.OrganizedTrip.OrganizedTrip> GetBookedTrips(TicketBookedTrip filter);
    }
}
