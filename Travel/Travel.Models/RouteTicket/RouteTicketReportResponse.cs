using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Models.RouteTicket
{
    public class RouteTicketReportResponse
    {
        public long RouteId { get; set; }
        public Route.Route Route { get; set; }
        public long AgencyId { get; set; }
        public Agency.Agency Agency { get; set; }
        public double Amount { get; set; }

    }

}
