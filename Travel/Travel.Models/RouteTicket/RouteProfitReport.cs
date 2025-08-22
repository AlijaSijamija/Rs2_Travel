using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Enums;

namespace Travel.Models.RouteTicket
{
    public class RouteProfitReport
    {
        public long RouteId { get; set; }
        public string RouteName { get; set; }
        public BusType BusType { get; set; }
        public int TicketsSold { get; set; }
        public double TotalRevenue { get; set; }
        public double TotalCost { get; set; }
        public double TotalProfit { get; set; }
    }

}
