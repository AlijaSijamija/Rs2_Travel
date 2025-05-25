// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgencyModel _$AgencyModelFromJson(Map<String, dynamic> json) => AgencyModel(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      (json['cityId'] as num?)?.toInt(),
      json['web'] as String?,
      json['city'] == null
          ? null
          : CityModel.fromJson(json['city'] as Map<String, dynamic>),
      json['contact'] as String?,
      json['adminId'] as String?,
    );

Map<String, dynamic> _$AgencyModelToJson(AgencyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'web': instance.web,
      'contact': instance.contact,
      'cityId': instance.cityId,
      'adminId': instance.adminId,
      'city': instance.city,
    };
