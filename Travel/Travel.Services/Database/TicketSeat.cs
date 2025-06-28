using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Services.Domain.Base;

namespace Travel.Services.Database
{
    public class TicketSeat : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public long? TripTicketId{ get; set; }
        public TripTicket TripTicket { get; set; }
        public long? RouteTicketId { get; set; }
        public RouteTicket RouteTicket { get; set; }
        public string SeatNumber { get; set; }
        public string PassengerName { get; set; }
    }
}
