using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Travel.Models.OrganizedTrip;
using Travel.Services.Interfaces;

namespace Travel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]

    public class OrganizedTripController : BaseCRUDController<Models.OrganizedTrip.OrganizedTrip, Models.Filters.OrganizedTripSearchObject, Models.OrganizedTrip.OrganizedTripRequest, Models.OrganizedTrip.OrganizedTripRequest, long>
    {
        private readonly IRecomenderService _recommenderService;
        public OrganizedTripController(ILogger<BaseController<Models.OrganizedTrip.OrganizedTrip, Models.Filters.OrganizedTripSearchObject, long>> logger, IOrganizedTripService service, IRecomenderService recommenderService) : base(logger, service)
        {
            _recommenderService = recommenderService;
        }

        [HttpPost("reccomended")]
        public virtual List<OrganizedTrip> Reccomended([FromBody] Recommender request)
        {
            var result = _recommenderService.TrainRecommendationModel(request.PassengerId, request.TripId);
            return result;
        }
    }
}
