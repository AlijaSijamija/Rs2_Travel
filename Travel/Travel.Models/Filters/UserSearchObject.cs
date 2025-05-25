using Travel.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Models.Filters
{
    public class UserSearchObject
    {
        public string? FullName { get; set; }
        public UserTypes? UserTypes { get; set; }
    }
}
