import 'package:travel_admin/model/trip_service/trip_service.dart';
import 'package:travel_admin/providers/base_provider.dart';

class TripServiceProvider extends BaseProvider<TripServiceModel> {
  TripServiceProvider() : super("TripService");

  @override
  TripServiceModel fromJson(data) {
    // TODO: implement fromJson
    return TripServiceModel.fromJson(data);
  }
}
