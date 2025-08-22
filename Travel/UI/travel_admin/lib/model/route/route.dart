import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
import 'package:travel_admin/model/agency/agency.dart';
import 'package:travel_admin/model/city/city.dart';
import 'package:travel_admin/model/enums/bus_type.dart';
part 'route.g.dart';

@JsonSerializable()
class RouteModel {
  int? id;
  int? numberOfSeats;
  String? adminId;
  double? childPrice;
  double? adultPrice;
  int? toCityId;
  int? fromCityId;
  CityModel? toCity;
  CityModel? fromCity;
  String? travelTime;
  String? departureTime;
  String? arrivalTime;
  int? busType;
  int? agencyId;
  AgencyModel? agency;
  DateTime? validFrom;
  DateTime? validTo;
  RouteModel(
      this.id,
      this.numberOfSeats,
      this.adminId,
      this.adultPrice,
      this.childPrice,
      this.toCity,
      this.toCityId,
      this.fromCity,
      this.fromCityId,
      this.travelTime,
      this.departureTime,
      this.arrivalTime,
      this.agency,
      this.agencyId,
      this.validFrom,
      this.validTo,
      this.busType);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RouteModelToJson(this);
}
