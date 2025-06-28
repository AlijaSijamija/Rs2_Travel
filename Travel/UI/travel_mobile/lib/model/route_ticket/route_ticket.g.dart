// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteTicketModel _$RouteTicketModelFromJson(Map<String, dynamic> json) =>
    RouteTicketModel(
      (json['id'] as num?)?.toInt(),
      AccountModel.fromJson(json['passenger'] as Map<String, dynamic>),
      json['passengerId'] as String?,
      (json['price'] as num?)?.toDouble(),
      (json['routeId'] as num?)?.toInt(),
      RouteModel.fromJson(json['route'] as Map<String, dynamic>),
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
      'routeId': instance.routeId,
      'route': instance.route,
      'agencyId': instance.agencyId,
      'agency': instance.agency,
    };
