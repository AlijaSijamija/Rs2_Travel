import 'dart:convert';

import 'package:travel_mobile/model/route_ticket/route_ticket.dart';
import 'package:travel_mobile/providers/base_provider.dart';

class RouteTicketProvider extends BaseProvider<RouteTicketModel> {
  RouteTicketProvider() : super("RouteTicket");

  @override
  RouteTicketModel fromJson(data) {
    // TODO: implement fromJson
    return RouteTicketModel.fromJson(data);
  }

  Future<bool> pay([dynamic request]) async {
    var url = "${BaseProvider.baseUrl}RouteTicket/pay";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http!.post(uri, headers: headers, body: jsonRequest);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      return false;
    }
  }

  Future<List<dynamic>> getRouteTickets(String passengerId) async {
    var url = "${BaseProvider.baseUrl}RouteTicket/routeTickets/$passengerId";

    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getReservedSeats(int routeId) async {
    var url = "${BaseProvider.baseUrl}RouteTicket/reservedSeats/$routeId";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }
}
