using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Enums;
using Travel.Services.Domain.Base;

namespace Travel.Services.Database
{
    public class Route : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public int NumberOfSeats { get; set; }
        public int AvailableSeats { get; set; }
        public double AdultPrice { get; set; }
        public double ChildPrice { get; set; }
        public long FromCityId { get; set; }
        public City FromCity { get; set; }
        public long ToCityId { get; set; }
        public City ToCity { get; set; }
        public string TravelTime { get; set; }
        public TimeSpan DepartureTime { get; set; }
        public TimeSpan ArrivalTime { get; set; }
        public DateTime ValidFrom { get; set; }
        public DateTime ValidTo { get; set; }
        public long AgencyId { get; set; }
        public Agency Agency { get; set; }
        public BusType BusType { get; set; }
        public virtual ICollection<RouteTicket> RouteTickets { get; set; } = new List<RouteTicket>();
        public virtual ICollection<SavedRoutes> SavedRoutes { get; set; } = new List<SavedRoutes>();
    }
}
