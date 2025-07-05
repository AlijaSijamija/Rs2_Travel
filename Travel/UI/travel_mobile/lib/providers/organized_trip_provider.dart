import 'dart:convert';

import 'package:travel_mobile/model/organized_trip/organized_trip.dart';
import 'package:travel_mobile/model/search_result.dart';
import 'package:travel_mobile/providers/base_provider.dart';

class OrganizedTripProvider extends BaseProvider<OrganizedTripModel> {
  OrganizedTripProvider() : super("OrganizedTrip");

  @override
  OrganizedTripModel fromJson(data) {
    // TODO: implement fromJson
    return OrganizedTripModel.fromJson(data);
  }

  Future<SearchResult<OrganizedTripModel>> recommended(
      [dynamic request]) async {
    var url = "${BaseProvider.baseUrl}OrganizedTrip/reccomended";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http!.post(uri, headers: headers, body: jsonRequest);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      // Convert dynamic list to List<String>
      var result = SearchResult<OrganizedTripModel>();
      for (var item in data) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
  }
}
