using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Models.RouteTicket
{
    public class RouteProfitReport
    {
        public long RouteId { get; set; }
        public string RouteName { get; set; }
        public double TotalProfit { get; set; }
    }
}
