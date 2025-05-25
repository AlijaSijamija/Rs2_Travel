using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Travel.Models.Filters;
using Travel.Models.Notification;
using Travel.Services.Database;
using Travel.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Services.Services
{
    public class NotificationService : BaseCRUDService<Models.Notification.Notification, Database.Notification, NotificationSearchObject, NotificationRequest, NotificationRequest, long>, INotificationService
    {
        public NotificationService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Notification> AddFilter(IQueryable<Database.Notification> query, NotificationSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Heading))
            {
                filteredQuery = filteredQuery.Where(x => x.Heading.Contains(search.Heading));
            }

            return filteredQuery;
        }

        public override IQueryable<Database.Notification> AddInclude(IQueryable<Database.Notification> query, NotificationSearchObject? search = null)
        {
            query = query.Include("Section").Include("Admin");
            return base.AddInclude(query, search);
        }
    }
}
