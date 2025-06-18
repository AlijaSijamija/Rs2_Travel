using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Models.Route
{
    public class Route
    {
        public long Id { get; set; }
        public int NumberOfSeats { get; set; }
        public double AdultPrice { get; set; }
        public double ChildPrice { get; set; }
        public long FromCityId { get; set; }
        public City.City FromCity { get; set; }
        public long ToCityId { get; set; }
        public City.City ToCity { get; set; }
        public string TravelTime { get; set; }
        public TimeSpan DepartureTime { get; set; }
        public TimeSpan ArrivalTime { get; set; }
        public long AgencyId { get; set; }
        public Agency.Agency Agency { get; set; }
    }
}
