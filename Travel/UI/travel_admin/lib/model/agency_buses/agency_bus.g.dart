// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agency_bus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgencyBusModel _$AgencyBusModelFromJson(Map<String, dynamic> json) =>
    AgencyBusModel(
      (json['id'] as num?)?.toInt(),
      (json['busType'] as num?)?.toInt(),
      (json['agencyId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AgencyBusModelToJson(AgencyBusModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'busType': instance.busType,
      'agencyId': instance.agencyId,
    };
