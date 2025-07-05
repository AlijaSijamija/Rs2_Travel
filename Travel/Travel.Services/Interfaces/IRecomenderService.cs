using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Services.Interfaces
{
    public interface IRecomenderService
    {
        public List<Travel.Models.OrganizedTrip.OrganizedTrip> TrainRecommendationModel(string passengerId, long tripId);
    }
}
