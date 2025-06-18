import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
import 'package:travel_admin/model/account/account.dart';
import 'package:travel_admin/model/agency/agency.dart';
import 'package:travel_admin/model/route/route.dart';

part 'route_ticket.g.dart';

@JsonSerializable()
class RouteTicketModel {
  int? id;
  String? passengerId;
  AccountModel passenger;
  double? price;
  int? routeId;
  RouteModel route;
  int? agencyId;
  AgencyModel? agency;
  RouteTicketModel(this.id, this.passenger, this.passengerId, this.price,
      this.routeId, this.route);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory RouteTicketModel.fromJson(Map<String, dynamic> json) =>
      _$RouteTicketModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RouteTicketModelToJson(this);
}
