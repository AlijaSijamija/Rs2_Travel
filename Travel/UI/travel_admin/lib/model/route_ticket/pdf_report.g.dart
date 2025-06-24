// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PdfReportModel _$PdfReportModelFromJson(Map<String, dynamic> json) =>
    PdfReportModel(
      json['name'] as String?,
      (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PdfReportModelToJson(PdfReportModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
    };
