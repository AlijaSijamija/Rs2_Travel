import 'package:travel_admin/model/agency/agency.dart';
import 'package:travel_admin/providers/base_provider.dart';

class AgencyProvider extends BaseProvider<AgencyModel> {
  AgencyProvider() : super("Agency");

  @override
  AgencyModel fromJson(data) {
    // TODO: implement fromJson
    return AgencyModel.fromJson(data);
  }
}
