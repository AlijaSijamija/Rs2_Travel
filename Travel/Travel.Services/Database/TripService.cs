using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Services.Domain.Base;

namespace Travel.Services.Database
{
    public class TripService : BaseEntity
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public virtual ICollection<OrganizedTrip> Trips { get; set; } = new List<OrganizedTrip>();
    }
}
