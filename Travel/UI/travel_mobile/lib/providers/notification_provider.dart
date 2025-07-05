import 'dart:convert';
import 'package:travel_mobile/model/notification/notification.dart';
import 'package:travel_mobile/model/search_result.dart';
import 'package:travel_mobile/utils/util.dart';
import 'base_provider.dart';

class NotificationProvider extends BaseProvider<NotificationModel> {
  NotificationProvider() : super("Notification");

  @override
  NotificationModel fromJson(data) {
    return NotificationModel.fromJson(data);
  }

  Future<List<NotificationModel>> getReadNotifications(
      String passengerId) async {
    var url =
        "${BaseProvider.baseUrl}Notification/readNotifications/$passengerId";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return (data as List).map((e) => fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future markNotificationAsRead({dynamic filter}) async {
    var url = "${BaseProvider.baseUrl}Notification/markAsRead";

    if (filter != null) {
      var queryString = Uri(queryParameters: filter).query;
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
    } else {}
  }

  Future<SearchResult<NotificationModel>> getData() async {
    var url = "http://10.0.2.2:7005/api/Notification";

    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<NotificationModel>();
      for (var item in data) {
        result.result.add(fromJson(item));
      }
      // Map each item to NotificationModel
      return result;
    } else {
      throw Exception("Unknown error");
    }
  }
}
