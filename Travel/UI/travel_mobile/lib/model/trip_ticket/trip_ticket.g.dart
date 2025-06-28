// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripTicketModel _$TripTicketModelFromJson(Map<String, dynamic> json) =>
    TripTicketModel(
      (json['id'] as num?)?.toInt(),
      json['agency'] == null
          ? null
          : AgencyModel.fromJson(json['agency'] as Map<String, dynamic>),
      (json['agencyId'] as num?)?.toInt(),
      (json['numberOfPassengers'] as num?)?.toInt(),
      json['passenger'] == null
          ? null
          : AccountModel.fromJson(json['passenger'] as Map<String, dynamic>),
      json['passengerId'] as String?,
      (json['price'] as num?)?.toDouble(),
      json['trip'] == null
          ? null
          : OrganizedTripModel.fromJson(json['trip'] as Map<String, dynamic>),
      (json['tripId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TripTicketModelToJson(TripTicketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numberOfPassengers': instance.numberOfPassengers,
      'agencyId': instance.agencyId,
      'agency': instance.agency,
      'passengerId': instance.passengerId,
      'passenger': instance.passenger,
      'price': instance.price,
      'tripId': instance.tripId,
      'trip': instance.trip,
    };
