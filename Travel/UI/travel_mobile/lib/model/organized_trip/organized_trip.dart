import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
import 'package:travel_mobile/model/agency/agency.dart';
import 'package:travel_mobile/model/trip_service/trip_service.dart';
import 'package:travel_mobile/model/trip_ticket/trip_ticket.dart';

part 'organized_trip.g.dart';

@JsonSerializable()
class OrganizedTripModel {
  int? id;
  int? availableSeats;
  int? numberOfSeats;
  int? agencyId;
  AgencyModel? agency;
  String destination;
  DateTime? startDate;
  DateTime? endDate;
  double? price;
  String description;
  String contactInfo;
  String tripName;
  List<TripServiceModel> includedServices;
  List<TripTicketModel> tripTickets;
  OrganizedTripModel(
      this.id,
      this.availableSeats,
      this.agency,
      this.agencyId,
      this.description,
      this.destination,
      this.startDate,
      this.endDate,
      this.contactInfo,
      this.price,
      this.includedServices,
      this.tripName,
      this.tripTickets,
      this.numberOfSeats);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory OrganizedTripModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizedTripModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$OrganizedTripModelToJson(this);
}
