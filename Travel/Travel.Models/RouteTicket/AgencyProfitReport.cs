using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Enums;

namespace Travel.Models.RouteTicket
{
    public class AgencyProfitReport
    {
        public long AgencyId { get; set; }
        public string AgencyName { get; set; }
        public int TicketsSold { get; set; }
        public double TotalRevenue { get; set; }
        public double TotalCost { get; set; }
        public double TotalProfit { get; set; }
        public BusType BusType { get; set; }
    }

}
