import 'dart:convert';

import 'package:travel_mobile/model/trip_ticket/trip_ticket.dart';
import 'package:travel_mobile/providers/base_provider.dart';

class TripTicketProvider extends BaseProvider<TripTicketModel> {
  TripTicketProvider() : super("TripTicket");

  @override
  TripTicketModel fromJson(data) {
    // TODO: implement fromJson
    return TripTicketModel.fromJson(data);
  }

  Future<bool> pay([dynamic request]) async {
    var url = "${BaseProvider.baseUrl}TripTicket/pay";
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

  Future<List<dynamic>> getBookedTrips({dynamic filter}) async {
    var url = "${BaseProvider.baseUrl}TripTicket/bookedTrips";

    // Append query parameters if filter is not null
    if (filter != null) {
      var queryString = Uri(queryParameters: filter).query;
      url = "$url?$queryString";
    }

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
}
