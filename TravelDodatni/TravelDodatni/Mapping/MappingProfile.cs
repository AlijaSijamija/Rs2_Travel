using AutoMapper;
using TravelDodatni.Dtos.Notification;
using TravelDodatni.Dtos.User;

namespace TravelDodatni.Mapping
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<TravelDodatni.Database.Notification, Notification>();
            CreateMap<TravelDodatni.Database.User, UserResponse>();
        }
    }
}
