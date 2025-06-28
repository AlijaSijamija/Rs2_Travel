using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Account;
using Travel.Models.OrganizedTrip;

namespace Travel.Models.TripTicket
{
    public class TripTicket
    {
        public long Id { get; set; }
        public string PassengerId { get; set; }
        public UserResponse Passenger { get; set; }
        public double Price { get; set; }
        public long TripId { get; set; }
        public OrganizedTrip.OrganizedTrip Trip { get; set; }
        public long AgencyId { get; set; }
        public Agency.Agency Agency { get; set; }
        public int NumberOfPassengers { get; set; }
    }
}
