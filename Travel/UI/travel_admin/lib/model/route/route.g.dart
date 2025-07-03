// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteModel _$RouteModelFromJson(Map<String, dynamic> json) => RouteModel(
      (json['id'] as num?)?.toInt(),
      (json['numberOfSeats'] as num?)?.toInt(),
      json['adminId'] as String?,
      (json['adultPrice'] as num?)?.toDouble(),
      (json['childPrice'] as num?)?.toDouble(),
      json['toCity'] == null
          ? null
          : CityModel.fromJson(json['toCity'] as Map<String, dynamic>),
      (json['toCityId'] as num?)?.toInt(),
      json['fromCity'] == null
          ? null
          : CityModel.fromJson(json['fromCity'] as Map<String, dynamic>),
      (json['fromCityId'] as num?)?.toInt(),
      json['travelTime'] as String?,
      json['departureTime'] as String?,
      json['arrivalTime'] as String?,
      json['agency'] == null
          ? null
          : AgencyModel.fromJson(json['agency'] as Map<String, dynamic>),
      (json['agencyId'] as num?)?.toInt(),
      json['validFrom'] == null
          ? null
          : DateTime.parse(json['validFrom'] as String),
      json['validTo'] == null
          ? null
          : DateTime.parse(json['validTo'] as String),
    );

Map<String, dynamic> _$RouteModelToJson(RouteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numberOfSeats': instance.numberOfSeats,
      'adminId': instance.adminId,
      'childPrice': instance.childPrice,
      'adultPrice': instance.adultPrice,
      'toCityId': instance.toCityId,
      'fromCityId': instance.fromCityId,
      'toCity': instance.toCity,
      'fromCity': instance.fromCity,
      'travelTime': instance.travelTime,
      'departureTime': instance.departureTime,
      'arrivalTime': instance.arrivalTime,
      'agencyId': instance.agencyId,
      'agency': instance.agency,
      'validFrom': instance.validFrom?.toIso8601String(),
      'validTo': instance.validTo?.toIso8601String(),
    };
