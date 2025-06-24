import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:travel_admin/model/route_ticket/agency_profit_report.dart';
import 'package:travel_admin/model/route_ticket/pdf_report.dart';
import 'package:travel_admin/model/route_ticket/route_profit_report.dart';
import 'package:travel_admin/model/route_ticket/route_ticket.dart';
import 'package:travel_admin/providers/base_provider.dart';

class RouteTicketProvider extends BaseProvider<RouteTicketModel> {
  RouteTicketProvider() : super("RouteTicket");

  @override
  RouteTicketModel fromJson(data) {
    // TODO: implement fromJson
    return RouteTicketModel.fromJson(data);
  }

  Future<List<AgencyProfitReportModel>> getAgencyProfitReport(
      {dynamic filter}) async {
    var url = "${BaseProvider.baseUrl}RouteTicket/agency-profit";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = <AgencyProfitReportModel>[];

      for (var item in data) {
        result.add(AgencyProfitReportModel.fromJson(item));
      }
      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<List<RouteProfitReportModel>> getRouteProfitReport(
      {dynamic filter}) async {
    var url = "${BaseProvider.baseUrl}RouteTicket/route-profit";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = <RouteProfitReportModel>[];

      for (var item in data) {
        result.add(RouteProfitReportModel.fromJson(item));
      }
      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<List<PdfReportModel>> getPdfData({dynamic filter}) async {
    var url = "${BaseProvider.baseUrl}RouteTicket/pdf-report";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = <PdfReportModel>[];

      for (var item in data) {
        result.add(PdfReportModel.fromJson(item));
      }
      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }
}
