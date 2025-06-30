using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Services.Domain.Base;

namespace Travel.Services.Database
{
    public class RouteTicket : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string PassengerId { get; set; }
        public User Passenger { get; set; }
        public double Price { get; set; }
        public long  RouteId { get; set; }
        public Route Route { get; set; }
        public long AgencyId { get; set; }
        public Agency Agency { get; set; }
        public virtual ICollection<TicketSeat> TicketSeats { get; set; } = new List<TicketSeat>();
    }
}
