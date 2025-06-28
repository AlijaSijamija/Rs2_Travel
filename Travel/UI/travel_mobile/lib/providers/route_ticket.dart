import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:travel_mobile/model/route_ticket/route_ticket.dart';
import 'package:travel_mobile/providers/base_provider.dart';

class RouteTicketProvider extends BaseProvider<RouteTicketModel> {
  RouteTicketProvider() : super("RouteTicket");

  @override
  RouteTicketModel fromJson(data) {
    // TODO: implement fromJson
    return RouteTicketModel.fromJson(data);
  }
}
