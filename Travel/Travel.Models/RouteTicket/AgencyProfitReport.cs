using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Models.RouteTicket
{
    public class AgencyProfitReport
    {
        public long AgencyId { get; set; }
        public string AgencyName { get; set; }
        public double TotalProfit { get; set; }
    }

}
