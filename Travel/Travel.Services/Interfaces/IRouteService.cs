using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Agency;
using Travel.Models.Filters;
using Travel.Models.Route;

namespace Travel.Services.Interfaces
{
    public interface IRouteService : ICRUDService<Models.Route.Route, RouteSearchObject, RouteRequest, RouteRequest, long>
    {
        void SaveRoute(SaveRoute saveRoute);
        void RemoveSavedRoute(SaveRoute saveRoute);
        List<Models.Route.Route> GetSavedRoutes(string passengerId);
    }
}
