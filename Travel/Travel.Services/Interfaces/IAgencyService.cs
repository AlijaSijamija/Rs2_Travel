using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Agency;
using Travel.Models.Filters;
using Travel.Models.Notification;

namespace Travel.Services.Interfaces
{
    public interface IAgencyService : ICRUDService<Models.Agency.Agency, AgencySearchObject, AgencyRequest, AgencyRequest, long>
    {
    }
}
