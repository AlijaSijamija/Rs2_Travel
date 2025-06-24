import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
import 'package:travel_mobile/model/city/city.dart';
part 'agency.g.dart';

@JsonSerializable()
class AgencyModel {
  int? id;
  String? name;
  String? web;
  String? contact;
  int? cityId;
  String? adminId;
  CityModel? city;

  AgencyModel(this.id, this.name, this.cityId, this.web, this.city,
      this.contact, this.adminId);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory AgencyModel.fromJson(Map<String, dynamic> json) =>
      _$AgencyModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AgencyModelToJson(this);
}
