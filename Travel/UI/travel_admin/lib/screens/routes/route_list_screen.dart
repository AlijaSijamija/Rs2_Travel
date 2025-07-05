import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_admin/model/city/city.dart';
import 'package:travel_admin/model/route/route.dart';
import 'package:travel_admin/model/search_result.dart';
import 'package:travel_admin/providers/city_provider.dart';
import 'package:travel_admin/providers/route_provider.dart';
import 'package:travel_admin/screens/notifications/notification_list_screen.dart';
import 'package:travel_admin/screens/routes/route_details_screen.dart';
import 'package:travel_admin/widgets/master_screen.dart';

class RouteListScreen extends StatefulWidget {
  const RouteListScreen({super.key});

  @override
  State<RouteListScreen> createState() => _RouteListScreenState();
  void functionThatSetsTheState() {}
}

class _RouteListScreenState extends State<RouteListScreen> {
  late RouteProvider _routeProvider;
  SearchResult<RouteModel>? result;
  late CityProvider _cityProvider;
  SearchResult<CityModel>? citiesResult;
  String? selectedCityToValue;
  String? selectedCityFromValue;
  TextEditingController _headingController = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _cityProvider = context.read<CityProvider>();
    _routeProvider = context.read<RouteProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    citiesResult = await _cityProvider.get();
    var data = await _routeProvider.get();
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Route list"),
      child: Container(
        child: Column(children: [_buildSearch(), _buildDataListView()]),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: DropdownButton<String>(
              value: selectedCityFromValue,
              hint: Text('Select city from'),
              onChanged: (newValue) async {
                setState(() {
                  selectedCityFromValue = newValue;
                });

                var filter = {
                  'fromCityId': selectedCityFromValue,
                  'toCityId': selectedCityToValue
                };

                if (selectedCityFromValue == null) {
                  filter['fromCityId'] = null;
                }

                var data = await _routeProvider.get(filter: filter);

                setState(() {
                  result = data;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: null, // Use null value for "All" option
                  child: Text('All cities from'),
                ),
                ...?citiesResult?.result.map((item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(item.name ?? ""),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: DropdownButton<String>(
              value: selectedCityFromValue,
              hint: Text('Select city to'),
              onChanged: (newValue) async {
                setState(() {
                  selectedCityToValue = newValue;
                });

                var filter = {
                  'fromCityId': selectedCityFromValue,
                  'toCityId': selectedCityToValue
                };

                if (selectedCityToValue == null) {
                  filter['toCityId'] = null;
                }

                var data = await _routeProvider.get(filter: filter);

                setState(() {
                  result = data;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: null, // Use null value for "All" option
                  child: Text('All cities to'),
                ),
                ...?citiesResult?.result.map((item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(item.name ?? ""),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RouteDetailScreen(
                      route: null,
                    ),
                  ),
                );
              },
              child: Text("Add new"))
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: DataTable(
            columnSpacing: 24.0,
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.indigo),
            dataRowColor:
                MaterialStateColor.resolveWith((states) => Colors.white),
            columns: [
              DataColumn(
                label: Text(
                  'Agency',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'From city',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'To city',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
            ],
            rows: result?.result.map((RouteModel e) {
                  void onRowTap() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RouteDetailScreen(route: e),
                      ),
                    );
                  }

                  return DataRow(
                    cells: [
                      DataCell(Text(e.agency?.name ?? ""), onTap: onRowTap),
                      DataCell(Text(e.fromCity?.name ?? ""), onTap: onRowTap),
                      DataCell(Text(e.toCity?.name ?? ""), onTap: onRowTap),
                    ],
                  );
                }).toList() ??
                [],
          ),
        ),
      ),
    );
  }
}
