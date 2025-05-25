using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;
using Travel.Services.Domain.Base;

namespace Travel.Services.Database
{
    public class City : BaseEntity
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public ICollection<User> Users { get; set; }
        public ICollection<Agency> Agencies { get; set; }
        public ICollection<Route> FromRoutes { get; set; }
        public ICollection<Route> ToRoutes { get; set; }
    }
}
