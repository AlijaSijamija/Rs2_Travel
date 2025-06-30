using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Models.TicketSeat
{
    public class TicketSeatRequest
    {
        public long? TripTicketId { get; set; }
        public long? RouteTicketId { get; set; }
        public string SeatNumber { get; set; }
        public string PassengerName { get; set; }
    }
}
