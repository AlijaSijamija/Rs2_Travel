using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Models.Filters
{
    public class RouteTicketSearchObject : BaseSearchObject
    {
        public string ? PassengerId { get; set; }
        public long ? RouteId { get; set; }
    }
}
