import 'package:json_annotation/json_annotation.dart';

part 'trip_service.g.dart';

@JsonSerializable()
class TripServiceModel {
  int? id;
  String? name;

  TripServiceModel(this.id, this.name);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory TripServiceModel.fromJson(Map<String, dynamic> json) =>
      _$TripServiceModelFromJson(json);

  // /// `toJson` is the convention for a class to declare support for serialization
  // /// to JSON. The implementation simply calls the private, generated
  // /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$TripServiceModelToJson(this);
}
