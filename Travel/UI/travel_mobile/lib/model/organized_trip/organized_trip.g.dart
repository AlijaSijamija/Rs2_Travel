// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organized_trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizedTripModel _$OrganizedTripModelFromJson(Map<String, dynamic> json) =>
    OrganizedTripModel(
      (json['id'] as num?)?.toInt(),
      (json['availableSeats'] as num?)?.toInt(),
      json['agency'] == null
          ? null
          : AgencyModel.fromJson(json['agency'] as Map<String, dynamic>),
      (json['agencyId'] as num?)?.toInt(),
      json['description'] as String,
      json['destination'] as String,
      json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      json['contactInfo'] as String,
      (json['price'] as num?)?.toDouble(),
      (json['includedServices'] as List<dynamic>)
          .map((e) => TripServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['tripName'] as String,
      (json['tripTickets'] as List<dynamic>)
          .map((e) => TripTicketModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['numberOfSeats'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrganizedTripModelToJson(OrganizedTripModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'availableSeats': instance.availableSeats,
      'numberOfSeats': instance.numberOfSeats,
      'agencyId': instance.agencyId,
      'agency': instance.agency,
      'destination': instance.destination,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'price': instance.price,
      'description': instance.description,
      'contactInfo': instance.contactInfo,
      'tripName': instance.tripName,
      'includedServices': instance.includedServices,
      'tripTickets': instance.tripTickets,
    };
