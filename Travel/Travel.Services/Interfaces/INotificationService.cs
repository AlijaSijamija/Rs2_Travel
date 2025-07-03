using Travel.Models.Filters;
using Travel.Models.Notification;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Services.Interfaces
{
    public  interface INotificationService : ICRUDService<Models.Notification.Notification, NotificationSearchObject, NotificationRequest, NotificationRequest, long>
    {
        void MarkNotificationAsRead(Models.Notification.ReadNotification readNotification);
        List<Models.Notification.Notification> GetReadNotification(string passengerId);
    }
}
