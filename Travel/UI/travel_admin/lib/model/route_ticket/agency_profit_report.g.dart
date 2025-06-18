// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agency_profit_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgencyProfitReportModel _$AgencyProfitReportModelFromJson(
        Map<String, dynamic> json) =>
    AgencyProfitReportModel(
      (json['agencyId'] as num?)?.toInt(),
      json['agencyName'] as String?,
      (json['totalProfit'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AgencyProfitReportModelToJson(
        AgencyProfitReportModel instance) =>
    <String, dynamic>{
      'agencyId': instance.agencyId,
      'agencyName': instance.agencyName,
      'totalProfit': instance.totalProfit,
    };
