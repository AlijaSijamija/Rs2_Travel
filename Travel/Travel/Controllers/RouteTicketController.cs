using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Drawing;
using Travel.Models.Filters;
using Travel.Models.Payment;
using Travel.Models.Route;
using Travel.Models.RouteTicket;
using Travel.Services.Interfaces;

namespace Travel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RouteTicketController : BaseCRUDController<Travel.Models.RouteTicket.RouteTicket, Travel.Models.Filters.RouteTicketSearchObject, Travel.Models.RouteTicket.RouteTicketRequest, Travel.Models.RouteTicket.RouteTicketRequest, long>
    {
        private readonly IPaymentService _paymentTicketService;
        public RouteTicketController(ILogger<BaseController<Travel.Models.RouteTicket.RouteTicket, Travel.Models.Filters.RouteTicketSearchObject, long>> logger, IRouteTicketService service, IPaymentService paymentTicketService) : base(logger, service)
        {
            _paymentTicketService = paymentTicketService;
        }

        [HttpGet("route-profit")]
        public virtual List<Travel.Models.RouteTicket.RouteProfitReport> GetProfitByRoute([FromQuery] AgencyProfitSearchObject searchObject)
        {
            var result = (_service as IRouteTicketService).GetProfitByRouteForAgency(searchObject);
            return result.ToList();
        }

        [HttpGet("agency-profit")]
        public virtual List<Travel.Models.RouteTicket.AgencyProfitReport> GetPaymentReport([FromQuery] AgencyProfitSearchObject searchObject)
        {
            var result = (_service as IRouteTicketService).GetProfitByAgency(searchObject);
            return result.ToList();
        }

        [HttpGet("pdf-report")]
        public virtual List<PaymentDataPDF> PaymentPdfData([FromQuery] PaymentReportSearchObject request)
        {
            var result = (_service as IRouteTicketService).GeneratePaymentData(request.Year ?? DateTime.Now.Year, request.AgencyId, request.BusTypes);
            return result.ToList();
        }

        [HttpPost("pay")]
        public virtual async Task<bool> Pay([FromBody] PaymentTicket request)
        {
            var result = await _paymentTicketService.Pay(request);
            return result;
        }

        [HttpGet("routeTickets/{passengerId}")]
        public virtual List<Models.Route.Route> GetRouteTickets([FromRoute] string passengerId)
        {
            var result = (_service as IRouteTicketService).GetRouteTickets(passengerId);
            return result;
        }

        [HttpGet("reservedSeats/{routeId}")]
        public virtual List<Models.TicketSeat.TicketSeat> GetReservedSeats([FromRoute] long routeId)
        {
            var result = (_service as IRouteTicketService).GetReservedSeats(routeId);
            return result;
        }
    }
}
