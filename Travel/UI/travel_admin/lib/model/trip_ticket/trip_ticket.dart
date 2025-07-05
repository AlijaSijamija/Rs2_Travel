import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
import 'package:travel_admin/model/account/account.dart';
import 'package:travel_admin/model/agency/agency.dart';
import 'package:travel_admin/model/organized_trip/organized_trip.dart';

part 'trip_ticket.g.dart';

@JsonSerializable()
class TripTicketModel {
  int? id;
  int? numberOfPassengers;
  int? agencyId;
  AgencyModel? agency;
  String? passengerId;
  AccountModel? passenger;
  double? price;
  int? tripId;
  OrganizedTripModel? trip;
  TripTicketModel(this.id, this.agency, this.agencyId, this.numberOfPassengers,
      this.passenger, this.passengerId, this.price, this.trip, this.tripId);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory TripTicketModel.fromJson(Map<String, dynamic> json) =>
      _$TripTicketModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$TripTicketModelToJson(this);
}
