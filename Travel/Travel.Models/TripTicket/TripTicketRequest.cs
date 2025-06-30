using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Account;
using Travel.Models.TicketSeat;

namespace Travel.Models.TripTicket
{
    public class TripTicketRequest
    {
        public string PassengerId { get; set; }
        public double Price { get; set; }
        public long TripId { get; set; }
        public int NumberOfPassengers { get; set; }
        public List<TicketSeatRequest> SeatNumbers { get; set; }
    }
}
