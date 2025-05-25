using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Services.Domain.Base;

namespace Travel.Services.Database
{
    public class Agency : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Web { get; set; }
        public string Contact { get; set; }
        public long CityId { get; set; }
        public City City { get; set; }
        public string AdminId { get; set; }
        public User Admin { get; set; }
        public virtual ICollection<Route> Routes { get; set; } = new List<Route>();
    }
}
