using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Travel.Models.Filters;
using Travel.Models.Route;
using Travel.Models.RouteTicket;
using Travel.Services.Interfaces;

namespace Travel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RouteTicketController : BaseCRUDController<Travel.Models.RouteTicket.RouteTicket, Travel.Models.Filters.RouteTicketSearchObject, Travel.Models.RouteTicket.RouteTicketRequest, Travel.Models.RouteTicket.RouteTicketRequest, long>
    {
        public RouteTicketController(ILogger<BaseController<Travel.Models.RouteTicket.RouteTicket, Travel.Models.Filters.RouteTicketSearchObject, long>> logger, IRouteTicketService service) : base(logger, service)
        {

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
            var result = (_service as IRouteTicketService).GeneratePaymentData(request.Year ?? DateTime.Now.Year, request.AgencyId);
            return result.ToList();
        }
    }
}
