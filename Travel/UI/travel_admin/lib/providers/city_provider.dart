import 'package:travel_admin/model/city/city.dart';
import 'package:travel_admin/providers/base_provider.dart';

class CityProvider extends BaseProvider<CityModel> {
  CityProvider() : super("City");

  @override
  CityModel fromJson(data) {
    // TODO: implement fromJson
    return CityModel.fromJson(data);
  }
}
