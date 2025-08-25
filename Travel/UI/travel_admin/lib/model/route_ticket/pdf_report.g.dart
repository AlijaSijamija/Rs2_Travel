// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PdfReportModel _$PdfReportModelFromJson(Map<String, dynamic> json) =>
    PdfReportModel(
      json['name'] as String?,
      (json['price'] as num?)?.toDouble(),
      (json['ticketsSold'] as num?)?.toInt(),
      (json['expense'] as num?)?.toDouble(),
      (json['income'] as num?)?.toDouble(),
      (json['profit'] as num?)?.toDouble(),
      (json['busType'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PdfReportModelToJson(PdfReportModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'ticketsSold': instance.ticketsSold,
      'expense': instance.expense,
      'profit': instance.profit,
      'income': instance.income,
      'busType': instance.busType,
    };
