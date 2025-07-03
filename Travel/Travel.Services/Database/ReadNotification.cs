using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Services.Domain.Base;

namespace Travel.Services.Database
{
    public class ReadNotification : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string PassengerId { get; set; }
        public User Passenger { get; set; }
        public long NotificationId { get; set; }
        public Notification Notification { get; set; }
    }
}
