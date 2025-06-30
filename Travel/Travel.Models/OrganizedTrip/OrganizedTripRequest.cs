using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Models.OrganizedTrip
{
    public class OrganizedTripRequest
    {

        public string TripName { get; set; }

        public string Destination { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public double Price { get; set; }

        public int NumberOfSeats { get; set; }

        public string Description { get; set; }

        public long AgencyId { get; set; }

        public string ContactInfo { get; set; }
        public  List<long> IncludedServicesIds { get; set; } 
    }
}
