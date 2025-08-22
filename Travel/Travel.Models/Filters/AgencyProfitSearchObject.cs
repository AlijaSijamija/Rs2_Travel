using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Enums;

namespace Travel.Models.Filters
{
    public class AgencyProfitSearchObject
    {
        public long ? AgencyId { get; set; }
        public int Year { get; set; }
        public List<int>? BusTypes { get; set; }
    }
}
