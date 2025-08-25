import 'package:json_annotation/json_annotation.dart';

part 'agency_bus.g.dart';

@JsonSerializable()
class AgencyBusModel {
  int? id;
  int? busType;
  int? agencyId;
  AgencyBusModel(this.id, this.busType, this.agencyId);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory AgencyBusModel.fromJson(Map<String, dynamic> json) =>
      _$AgencyBusModelFromJson(json);

  // /// `toJson` is the convention for a class to declare support for serialization
  // /// to JSON. The implementation simply calls the private, generated
  // /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AgencyBusModelToJson(this);
}
