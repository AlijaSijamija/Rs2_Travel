import 'package:travel_admin/model/organized_trip/organized_trip.dart';
import 'package:travel_admin/providers/base_provider.dart';

class OrganizedTripProvider extends BaseProvider<OrganizedTripModel> {
  OrganizedTripProvider() : super("OrganizedTrip");

  @override
  OrganizedTripModel fromJson(data) {
    // TODO: implement fromJson
    return OrganizedTripModel.fromJson(data);
  }
}
