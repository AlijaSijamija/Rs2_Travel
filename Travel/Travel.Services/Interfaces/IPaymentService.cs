using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Filters;
using Travel.Models.Notification;
using Travel.Models.Payment;

namespace Travel.Services.Interfaces
{
    public interface IPaymentService 
    {
        Task<bool> Pay(PaymentTicket vm);
    }
}
