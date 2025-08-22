using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Filters;
using Travel.Models.Route;
using Travel.Models.RouteTicket;

namespace Travel.Services.Interfaces
{
    public interface IRouteTicketService : ICRUDService<Models.RouteTicket.RouteTicket, RouteTicketSearchObject, RouteTicketRequest, RouteTicketRequest, long>
    {
       List<AgencyProfitReport> GetProfitByAgency(AgencyProfitSearchObject searchObject);
        List<RouteProfitReport> GetProfitByRouteForAgency(AgencyProfitSearchObject searchObject);
        List<PaymentDataPDF> GeneratePaymentData(int year, long? agencyId, List<int>? busTypes = null);
        List<Models.Route.Route> GetRouteTickets(string passengerId);
        List<Models.TicketSeat.TicketSeat> GetReservedSeats(long routeId);
    }
}
