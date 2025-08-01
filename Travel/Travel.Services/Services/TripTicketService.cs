﻿using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Filters;
using Travel.Services.Database;
using Travel.Services.Interfaces;

namespace Travel.Services.Services
{
    public class TripTicketService : BaseCRUDService<Models.TripTicket.TripTicket, Database.TripTicket, Models.Filters.BaseSearchObject, Models.TripTicket.TripTicketRequest, Models.TripTicket.TripTicketRequest, long>, ITripTicketService
    {
        public TripTicketService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override async Task BeforeInsert(Database.TripTicket entity, Models.TripTicket.TripTicketRequest insert)
        {
            var trip = _context.OrganizedTrips.FirstOrDefault(t => t.Id == insert.TripId);
            entity.AgencyId = trip.AgencyId;
            trip.AvailableSeats = trip.AvailableSeats - insert.NumberOfPassengers;
            var list = new List<TicketSeat>();

            if (insert.SeatNumbers != null)
            {
                foreach (var item in insert.SeatNumbers)
                {
                    var seatNumber = new TicketSeat
                    {
                        SeatNumber = item.SeatNumber,
                        PassengerName = item.PassengerName
                    };
                    list.Add(seatNumber);
                }
            }

            entity.TicketSeats = list;
        }

        public List<Models.OrganizedTrip.OrganizedTrip> GetBookedTrips(TicketBookedTrip filter)
        {
            var trips = _context.OrganizedTrips.Include(o => o.TripTickets).ThenInclude(o => o.Passenger).Include(o => o.Agency).ToList();
            if (!string.IsNullOrWhiteSpace(filter?.PassengerId))
            {
                trips = trips.Where(o => o.TripTickets.Any(t => t.PassengerId == filter.PassengerId)).ToList();
            }

            if (filter.Passed.HasValue && filter.Passed.Value)
            {
                trips = trips.Where(o => o.EndDate < DateTime.UtcNow).ToList();
            }
            else
            {
                trips = trips.Where(o => o.EndDate > DateTime.UtcNow).ToList();
            }


            return _mapper.Map<List<Models.OrganizedTrip.OrganizedTrip>>(trips);
        }

        public List<Models.TicketSeat.TicketSeat> GetReservedSeats(long tripId)
        {
            var reservedSeats = _context.TicketSeats
                .Include(t=>t.TripTicket)
                .Where(s => s.TripTicket!= null && s.TripTicket.TripId == tripId)
                .ToList();

            return _mapper.Map<List<Models.TicketSeat.TicketSeat>>(reservedSeats);
        }

    }
}
