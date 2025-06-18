

using Travel.Models.TripService;

namespace Travel.Services.Interfaces
{
    public interface ITripServiceService : ICRUDService<Models.TripService.TripService, Models.Filters.BaseSearchObject, TripService, TripService, long>
    {
    }
}
