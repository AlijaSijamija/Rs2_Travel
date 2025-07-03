// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteTicketModel _$RouteTicketModelFromJson(Map<String, dynamic> json) =>
    RouteTicketModel(
      (json['id'] as num?)?.toInt(),
      json['passenger'] == null
          ? null
          : AccountModel.fromJson(json['passenger'] as Map<String, dynamic>),
      json['passengerId'] as String?,
      (json['price'] as num?)?.toDouble(),
      (json['numberOfAdultPassengers'] as num?)?.toInt(),
      (json['numberOfChildPassengers'] as num?)?.toInt(),
    )
      ..agencyId = (json['agencyId'] as num?)?.toInt()
      ..agency = json['agency'] == null
          ? null
          : AgencyModel.fromJson(json['agency'] as Map<String, dynamic>);

Map<String, dynamic> _$RouteTicketModelToJson(RouteTicketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'passengerId': instance.passengerId,
      'passenger': instance.passenger,
      'price': instance.price,
      'agencyId': instance.agencyId,
      'agency': instance.agency,
      'numberOfAdultPassengers': instance.numberOfAdultPassengers,
      'numberOfChildPassengers': instance.numberOfChildPassengers,
    };
