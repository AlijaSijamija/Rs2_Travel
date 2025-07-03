using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Account;

namespace Travel.Models.RouteTicket
{
    public class RouteTicket
    {
        public long Id { get; set; }
        public int NumberOfAdultPassengers { get; set; }
        public int NumberOfChildPassengers { get; set; }
        public string PassengerId { get; set; }
        public UserResponse Passenger { get; set; }
        public double Price { get; set; }
        public DateTime? DepartureDate { get; set; }
        public DateTime ArrivalDate { get; set; }
    }
}
