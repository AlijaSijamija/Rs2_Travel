using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Agency;
using Travel.Models.Filters;
using Travel.Models.OrganizedTrip;

namespace Travel.Services.Interfaces
{
    public interface IOrganizedTripService : ICRUDService<Models.OrganizedTrip.OrganizedTrip, OrganizedTripSearchObject, OrganizedTripRequest, OrganizedTripRequest, long>
    {
    }
}
