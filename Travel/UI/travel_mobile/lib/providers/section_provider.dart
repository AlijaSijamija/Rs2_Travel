import 'package:travel_mobile/model/section/section.dart';
import 'base_provider.dart';

class SectionProvider extends BaseProvider<SectionModel> {
  SectionProvider() : super("Section");

  @override
  SectionModel fromJson(data) {
    // TODO: implement fromJson
    return SectionModel.fromJson(data);
  }
}
