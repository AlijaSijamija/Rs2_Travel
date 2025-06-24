import 'package:travel_mobile/model/route/route.dart';
import 'package:travel_mobile/providers/base_provider.dart';

class RouteProvider extends BaseProvider<RouteModel> {
  RouteProvider() : super("Route");

  @override
  RouteModel fromJson(data) {
    // TODO: implement fromJson
    return RouteModel.fromJson(data);
  }
}
