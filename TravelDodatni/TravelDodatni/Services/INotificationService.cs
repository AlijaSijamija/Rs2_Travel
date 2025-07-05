using TravelDodatni.Dtos.Notification;

namespace TravelDodatni.Services
{
    public interface INotificationService
    {
        public Task<List<Notification>> Get();
    }
}
