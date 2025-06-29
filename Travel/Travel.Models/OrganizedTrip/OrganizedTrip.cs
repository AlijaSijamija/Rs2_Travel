using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Agency;

namespace Travel.Models.OrganizedTrip
{
    public class OrganizedTrip
    {
        public long Id { get; set; }

        public string TripName { get; set; }

        public string Destination { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public double Price { get; set; }

        public int AvailableSeats { get; set; }

        public string Description { get; set; }

        public long AgencyId { get; set; }
        public Agency.Agency Agency { get; set; }

        public string ContactInfo { get; set; }
        public  List<TripService.TripService> IncludedServices { get; set; } 
        public  List<TripTicket.TripTicket> TripTickets { get; set; } 
    }
}
