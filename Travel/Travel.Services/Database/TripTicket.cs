using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Services.Domain.Base;

namespace Travel.Services.Database
{
    public class TripTicket : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string PassengerId { get; set; }
        public User Passenger { get; set; }
        public double Price { get; set; }
        public long TripId { get; set; }
        public OrganizedTrip Trip { get; set; }
        public long AgencyId { get; set; }
        public Agency Agency { get; set; }
        public  int NumberOfPassengers{ get; set; }
    }
}
