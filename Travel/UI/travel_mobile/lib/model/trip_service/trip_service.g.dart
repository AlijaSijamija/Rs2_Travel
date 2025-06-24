// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripServiceModel _$TripServiceModelFromJson(Map<String, dynamic> json) =>
    TripServiceModel(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
    );

Map<String, dynamic> _$TripServiceModelToJson(TripServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
