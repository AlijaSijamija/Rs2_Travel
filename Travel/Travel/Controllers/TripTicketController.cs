using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Travel.Models.Filters;
using Travel.Models.Payment;
using Travel.Services.Interfaces;

namespace Travel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TripTicketController : BaseCRUDController<Models.TripTicket.TripTicket, Models.Filters.BaseSearchObject, Models.TripTicket.TripTicketRequest, Models.TripTicket.TripTicketRequest, long>
    {
        private readonly IPaymentService _paymentTicketService;
        public TripTicketController(ILogger<BaseController<Models.TripTicket.TripTicket, Models.Filters.BaseSearchObject, long>> logger, ITripTicketService service, IPaymentService paymentTicketService) : base(logger, service)
        {
            _paymentTicketService = paymentTicketService;
        }

        [HttpPost("pay")]
        public virtual async Task<bool> Pay([FromBody] PaymentTicket request)
        {
            var result = await _paymentTicketService.Pay(request);
            return result;
        }

        [HttpGet("bookedTrips")]
        public virtual List<Models.OrganizedTrip.OrganizedTrip> GetBookedTrips([FromQuery] TicketBookedTrip filter)
        {
            var result = (_service as ITripTicketService).GetBookedTrips(filter);
            return result;
        }
    }
}
