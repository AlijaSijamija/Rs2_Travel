using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Models.RouteTicket
{
    public  class PaymentDataPDF
    {
        public string Name { get; set; }
        public double Price { get; set; }
        public int TicketsSold { get; set; }
        public double Expense { get; set; }
        public double Profit { get; set; }
        public double Income { get; set; }
    }
}
