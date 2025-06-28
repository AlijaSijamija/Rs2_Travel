using AutoMapper;
using Microsoft.AspNetCore.Routing;
using Travel.Models.Agency;
using Travel.Models.City;
using Travel.Models.Notification;
using Travel.Models.OrganizedTrip;
using Travel.Models.Route;
using Travel.Models.RouteTicket;
using Travel.Models.Section;
using Travel.Models.TripService;
using Travel.Models.TripTicket;

namespace Travel.Services.MappingProfile
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {

            CreateMap<Database.City, City>();
            CreateMap<Database.Notification, Notification>();
            CreateMap<NotificationRequest, Database.Notification>();
            CreateMap<Database.Section, Section>();
            CreateMap<Database.User, Models.Account.UserResponse>();
            CreateMap<Database.Agency, Agency>();
            CreateMap<AgencyRequest, Database.Agency>();
            CreateMap<Database.Route, Travel.Models.Route.Route>();
            CreateMap<RouteRequest, Database.Route>();
            CreateMap<Database.TripService, TripService>();
            CreateMap<TripService, Database.TripService>();
            CreateMap<Database.OrganizedTrip, Travel.Models.OrganizedTrip.OrganizedTrip>();
            CreateMap<OrganizedTripRequest, Database.OrganizedTrip>();
            CreateMap<Database.RouteTicket, Travel.Models.RouteTicket.RouteTicket>();
            CreateMap<RouteTicketRequest, Database.RouteTicket>();
            CreateMap<Database.TripTicket, Travel.Models.TripTicket.TripTicket>();
            CreateMap<TripTicketRequest, Database.TripTicket>();
        }
    }
}
