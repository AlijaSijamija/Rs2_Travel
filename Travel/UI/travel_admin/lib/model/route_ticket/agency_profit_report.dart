import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'agency_profit_report.g.dart';

@JsonSerializable()
class AgencyProfitReportModel {
  int? agencyId;
  String? agencyName;
  double? totalProfit;
  int? ticketsSold;
  double? totalRevenue;
  double? totalCost;
  AgencyProfitReportModel(this.agencyId, this.agencyName, this.totalProfit,
      this.ticketsSold, this.totalCost, this.totalRevenue);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory AgencyProfitReportModel.fromJson(Map<String, dynamic> json) =>
      _$AgencyProfitReportModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AgencyProfitReportModelToJson(this);
}
