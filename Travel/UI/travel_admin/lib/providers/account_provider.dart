import 'dart:convert';
import 'package:http/http.dart';
import 'package:travel_admin/model/account/account.dart';
import 'package:travel_admin/model/account/dashboard_data.dart';
import 'package:travel_admin/model/account/token_info.dart';
import 'package:travel_admin/model/search_result.dart';
import 'package:travel_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import '../utils/util.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AccountProvider extends BaseProvider<AccountModel> {
  AccountProvider() : super("Account");

  @override
  AccountModel fromJson(data) {
    return AccountModel.fromJson(data);
  }

  Future<dynamic> login(dynamic body) async {
    var url = "${BaseProvider.baseUrl}Account/authenticate";
    var uri = Uri.parse(url);
    var jsonRequest = jsonEncode(body);
    var headers = createHeaders();
    var response = await http.post(
      uri,
      headers: headers,
      body: jsonRequest,
    );
    if (isValidAutheticateResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw new Exception("Unknown error");
    }
  }

  bool isValidAutheticateResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else {
      throw new Exception("Incorrect username or password");
    }
  }

  TokenInfoModel getCurrentUser() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(Authorization.token!);
    return TokenInfoModel.fromJson(decodedToken);
  }

  Future<AccountModel> userProfile(String id) async {
    var url = "${BaseProvider.baseUrl}Account/user-profile/$id";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return AccountModel.fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<SearchResult<AccountModel>> getStudentsForMentor(
      String mentorId) async {
    var url = "${BaseProvider.baseUrl}Account/mentor-students/$mentorId";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<AccountModel>();
      result.count = data['count'];
      for (var item in data['result']) {
        result.result.add(AccountModel.fromJson(item));
      }
      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<void> updateProfile(String id, [dynamic request]) async {
    var url = "${BaseProvider.baseUrl}Account/update-profile/$id";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);
    if (!isValidResponse(response)) {
      throw new Exception("Unknown error");
    }
  }

  Future<DashboardModel> getDashboardData() async {
    var url = "${BaseProvider.baseUrl}Account/dashboard-data";

    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = DashboardModel.fromJson(data);
      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<AccountModel> updateUser(String id, [dynamic request]) async {
    var url = "${BaseProvider.baseUrl}Account/update-user/$id";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return AccountModel.fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<AccountModel> register(dynamic request) async {
    var url = "${BaseProvider.baseUrl}Account/register";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return AccountModel.fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<SearchResult<AccountModel>> getAll({dynamic filter}) async {
    var url = "${BaseProvider.baseUrl}Account/get-all";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<AccountModel>();

      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<void> remove(String id) async {
    var url = "${BaseProvider.baseUrl}Account/remove/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (isValidResponse(response)) {
    } else {
      throw new Exception("Failed to delete user");
    }
  }
}
