using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Services.Domain.Base;

namespace Travel.Services.Database
{
    public class OrganizedTrip : BaseSoftDeleteEntity
    {
        public long Id { get; set; }

        public string TripName { get; set; }

        public string Destination { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public double Price { get; set; }

        public int AvailableSeats { get; set; }
        public int NumberOfSeats { get; set; }

        public string Description { get; set; }

        public long AgencyId { get; set; }
        public Agency Agency { get; set; }

        public string ContactInfo { get; set; }
        public virtual ICollection<TripService> IncludedServices { get; set; } = new List<TripService>();
        public virtual ICollection<TripTicket> TripTickets { get; set; } = new List<TripTicket>();
    }
}
