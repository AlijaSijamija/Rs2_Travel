// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_profit_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteProfitReportModel _$RouteProfitReportModelFromJson(
        Map<String, dynamic> json) =>
    RouteProfitReportModel(
      (json['routeId'] as num?)?.toInt(),
      json['routeName'] as String?,
      (json['totalProfit'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RouteProfitReportModelToJson(
        RouteProfitReportModel instance) =>
    <String, dynamic>{
      'routeId': instance.routeId,
      'routeName': instance.routeName,
      'totalProfit': instance.totalProfit,
    };
