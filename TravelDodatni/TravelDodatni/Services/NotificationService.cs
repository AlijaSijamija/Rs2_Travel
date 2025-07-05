using AutoMapper;
using TravelDodatni.Database;
using Microsoft.EntityFrameworkCore;
namespace TravelDodatni.Services
{
    public class NotificationService : INotificationService
    {
        private AppDbContext _appDbContext;
        private IMapper _mapper;
        public NotificationService(AppDbContext appDbContext, IMapper mapper)
        {
            _appDbContext = appDbContext;
            _mapper = mapper;
        }
        public async Task<List<Dtos.Notification.Notification>> Get()
        {
            var notifications = await _appDbContext.Notifications.ToListAsync();

            return _mapper.Map<List<Dtos.Notification.Notification>>(notifications);

        }
    }
}
