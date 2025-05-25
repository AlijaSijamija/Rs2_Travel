using Travel.Services.Database;
using Travel.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Services.Configuration
{
    internal class RolesSeed
    {
        public static Role[] Data =
        {
            new Role{ Id="18d19d79-4b90-4ae0-93ff-926b47a2ee49", Name=Roles.Admin},
            new Role{ Id= "af6475d1-b099-4c74-a7ea-1e4acfc11dad", Name=Roles.Passenger},
        };
    }
}
