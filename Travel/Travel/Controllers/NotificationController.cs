using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Travel.Models.Filters;
using Travel.Models.Notification;
using Travel.Services.Interfaces;

namespace Travel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationController : BaseCRUDController<Models.Notification.Notification, Models.Filters.NotificationSearchObject, Models.Notification.NotificationRequest, Models.Notification.NotificationRequest, long>
    {
        public NotificationController(ILogger<BaseController<Models.Notification.Notification, Models.Filters.NotificationSearchObject, long>> logger, INotificationService service) : base(logger, service)
        {
        }

        [HttpGet("readNotifications/{passengerId}")]
        public virtual List<Models.Notification.Notification> GetReadNotification([FromRoute] string passengerId)
        {
            var result = (_service as INotificationService).GetReadNotification(passengerId);
            return result;
        }

        [HttpGet("markAsRead")]
        public virtual void MarkNotificationAsRead([FromQuery] ReadNotification readNotification)
        {
           (_service as INotificationService).MarkNotificationAsRead(readNotification);
           
        }
    }
}
