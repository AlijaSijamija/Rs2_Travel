using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Services.Database;
using Travel.Services.Interfaces;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
namespace Travel.Services.Services
{
    public class RecomenderService : IRecomenderService
    {
        protected AppDbContext _context;
        protected IMapper _mapper { get; set; }
        public RecomenderService(AppDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public List<Database.OrganizedTrip> RecommendTravelsByUserAgencies(string userId, int topAgencyCount = 3, int recommendCount = 5)
        {
            var userTickets = _context.TripTickets
                .Include(tt => tt.Trip) 
                .Where(tt => tt.PassengerId == userId)
                .ToList();

            if (!userTickets.Any())
            {
                return new List<OrganizedTrip>();
            }

            var topAgencies = userTickets
                .GroupBy(tt => tt.Trip.AgencyId) 
                .Select(g => new { AgencyId = g.Key, Count = g.Count() })
                .OrderByDescending(g => g.Count)
                .Take(topAgencyCount)
                .Select(g => g.AgencyId)
                .ToList();

            var userTravelIds = userTickets.Select(tt => tt.TripId).ToList();

            var recommendedTravels = _context.OrganizedTrips
                .Where(ot => topAgencies.Contains(ot.AgencyId) && !userTravelIds.Contains(ot.Id))
                .OrderByDescending(ot => ot.StartDate)
                .Take(recommendCount)
                .ToList();

            return recommendedTravels;
        }


        static bool isModelTrained = false;

        public List<Travel.Models.OrganizedTrip.OrganizedTrip> TrainRecommendationModel(string passengerId, long tripId)
        {
            lock (isLocked)
            {
                if (!isModelTrained)
                {
                    mlContext = new MLContext();

                    var rawData = RecommendTravelsByUserAgencies(passengerId);

                    if (rawData == null || !rawData.Any())
                    {
                        return new List<Travel.Models.OrganizedTrip.OrganizedTrip>();
                    }

                    var mlData = rawData.Select(ot => new TripData
                    {
                        TripID = (uint)ot.Id,
                        CoTripID = (uint)ot.AgencyId,
                        Label = 1f
                    }).ToList();

                    var trainData = mlContext.Data.LoadFromEnumerable(mlData);

                    var options = new MatrixFactorizationTrainer.Options
                    {
                        MatrixColumnIndexColumnName = nameof(TripData.TripID),
                        MatrixRowIndexColumnName = nameof(TripData.CoTripID),
                        LabelColumnName = nameof(TripData.Label),
                        LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                        Alpha = 0.01f,
                        Lambda = 0.025f,
                        NumberOfIterations = 100,
                        C = 0.00001f
                    };

                    var estimator = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = estimator.Fit(trainData);

                    isModelTrained = true;

                    return this.RecommendTrips(passengerId, tripId);
                }
                else
                {
                    return this.RecommendTrips(passengerId, tripId);
                }
            }
        }

        public List<Travel.Models.OrganizedTrip.OrganizedTrip> RecommendTrips(string userId, long tripId)
        {
            if (mlContext == null || model == null)
            {
                return new List<Travel.Models.OrganizedTrip.OrganizedTrip>();
            }

            var trips = _context.OrganizedTrips.Where(e => e.Id != tripId).ToList();
            var predictionResults = new List<Tuple<OrganizedTrip, float>>();

            var bookedTrips = _context.TripTickets
                .Include(c => c.Trip)
                .Where(eu => eu.PassengerId == userId)
                .Select(eu => eu.TripId)
                .ToList();

            foreach (var e in trips)
            {
                if (!bookedTrips.Contains(e.Id)) // Exclude trips the user is already registered for
                {
                    var predictionEngine = mlContext.Model.CreatePredictionEngine<TripData, TripPrediction>(model);
                    var prediction = predictionEngine.Predict(new TripData
                    {
                        CoTripID = (uint)e.Id,
                        TripID = (uint)tripId
                    });

                    predictionResults.Add(new Tuple<OrganizedTrip, float>(e, prediction.Score));
                }
            }

            var recommendedTrips = predictionResults
                .OrderByDescending(x => x.Item2)
                .Take(2)
                .Select(x => x.Item1)
                .ToList();

            return _mapper.Map<List<Travel.Models.OrganizedTrip.OrganizedTrip>>(recommendedTrips);
        }

        public class TripPrediction
        {
            public float Score { get; set; }
        }
    }

    public class TripData
    {
        [KeyType(count: 10000)]
        public uint TripID { get; set; }

        [KeyType(count: 10000)]
        public uint CoTripID { get; set; }

        public float Label { get; set; }
    }

}
