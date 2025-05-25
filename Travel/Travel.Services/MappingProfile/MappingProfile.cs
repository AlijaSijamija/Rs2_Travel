using AutoMapper;
using Microsoft.AspNetCore.Routing;
using Travel.Models.Agency;
using Travel.Models.City;
using Travel.Models.Notification;
using Travel.Models.Route;
using Travel.Models.Section;

namespace Travel.Services.MappingProfile
{
    public  class MappingProfile : Profile
    {
        public MappingProfile()
        {

            CreateMap<Travel.Services.Database.City, City>();
            CreateMap<Database.Notification, Notification>();
            CreateMap<NotificationRequest, Database.Notification>();
            CreateMap<Database.Section, Section>();
            CreateMap<Database.User, Models.Account.UserResponse>();
            CreateMap<Database.Agency, Agency>();
            CreateMap<AgencyRequest, Database.Agency>();
            CreateMap<Database.Route, Travel.Models.Route.Route>();
            CreateMap<RouteRequest, Database.Route>();
        }
    }
}
