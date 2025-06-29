import 'dart:convert';

import 'package:travel_mobile/model/route/route.dart';
import 'package:travel_mobile/providers/base_provider.dart';

class RouteProvider extends BaseProvider<RouteModel> {
  RouteProvider() : super("Route");

  @override
  RouteModel fromJson(data) {
    // TODO: implement fromJson
    return RouteModel.fromJson(data);
  }

  Future<bool> saveRoute({dynamic filter}) async {
    var url = "${BaseProvider.baseUrl}Route/save-route";

    if (filter != null) {
      var queryString = Uri(queryParameters: filter).query;
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var response = await http!.post(uri, headers: headers);

    return isValidResponse(response);
  }

  Future<bool> removeSavedRoute({dynamic filter}) async {
    var url = "${BaseProvider.baseUrl}Route/remove-saved-route";

    if (filter != null) {
      var queryString = Uri(queryParameters: filter).query;
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var response = await http!.put(uri, headers: headers);

    return isValidResponse(response);
  }

  Future<List<RouteModel>> getSavedRoutes(String passengerId) async {
    var url = "${BaseProvider.baseUrl}Route/saved-routes/$passengerId";

    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var response = await http!.put(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data.map<RouteModel>((item) => fromJson(item)).toList();
    } else {
      return [];
    }
  }
}
