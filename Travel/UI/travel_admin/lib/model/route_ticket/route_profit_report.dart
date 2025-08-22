import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'route_profit_report.g.dart';

@JsonSerializable()
class RouteProfitReportModel {
  int? routeId;
  String? routeName;
  double? totalProfit;
  int? busType;
  int? ticketsSold;
  double? totalRevenue;
  double? totalCost;
  RouteProfitReportModel(this.routeId, this.routeName, this.totalProfit,
      this.busType, this.ticketsSold, this.totalCost, this.totalRevenue);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory RouteProfitReportModel.fromJson(Map<String, dynamic> json) =>
      _$RouteProfitReportModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RouteProfitReportModelToJson(this);
}
