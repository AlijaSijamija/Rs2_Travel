using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Account;
using Travel.Models.TicketSeat;

namespace Travel.Models.RouteTicket
{
    public class RouteTicketRequest
    {
        public string PassengerId { get; set; }
        public double Price { get; set; }
        public long RouteId { get; set; }
        public int NumberOfAdultPassengers { get; set; }
        public int NumberOfChildPassengers { get; set; }
        public DateTime? DepartureDate { get; set; }
        public DateTime ArrivalDate { get; set; }
        public List<TicketSeatRequest> SeatNumbers { get; set; }
    }
}
