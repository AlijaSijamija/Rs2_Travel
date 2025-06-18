using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Account;

namespace Travel.Models.RouteTicket
{
    public class RouteTicketRequest
    {
        public string PassengerId { get; set; }
        public double Price { get; set; }
        public long RouteId { get; set; }
    }
}
