// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardModel _$DashboardModelFromJson(Map<String, dynamic> json) =>
    DashboardModel(
      (json['passengerCount'] as num?)?.toInt(),
      (json['adminCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DashboardModelToJson(DashboardModel instance) =>
    <String, dynamic>{
      'adminCount': instance.adminCount,
      'passengerCount': instance.passengerCount,
    };
