import 'package:json_annotation/json_annotation.dart';

part 'pdf_report.g.dart';

@JsonSerializable()
class PdfReportModel {
  String? name;
  double? price;
  PdfReportModel(this.name, this.price);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory PdfReportModel.fromJson(Map<String, dynamic> json) =>
      _$PdfReportModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PdfReportModelToJson(this);
}
