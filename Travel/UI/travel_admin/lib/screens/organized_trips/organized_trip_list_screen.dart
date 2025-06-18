import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_admin/model/agency/agency.dart';
import 'package:travel_admin/model/organized_trip/organized_trip.dart';
import 'package:travel_admin/model/search_result.dart';
import 'package:travel_admin/providers/agency_provider.dart';
import 'package:travel_admin/providers/organized_trip_provider.dart';
import 'package:travel_admin/screens/organized_trips/organized_trip_details_screen.dart';
import 'package:travel_admin/widgets/master_screen.dart';

class OrganizedTripListScreen extends StatefulWidget {
  const OrganizedTripListScreen({super.key});

  @override
  State<OrganizedTripListScreen> createState() =>
      _OrganizedTripListScreenState();
  void functionThatSetsTheState() {}
}

class _OrganizedTripListScreenState extends State<OrganizedTripListScreen> {
  late OrganizedTripProvider _organizedTripProvider;
  SearchResult<OrganizedTripModel>? result;
  late AgencyProvider _agencyProvider;
  SearchResult<AgencyModel>? agenciesResult;
  String? selectedValue;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _organizedTripProvider = context.read<OrganizedTripProvider>();
    _agencyProvider = context.read<AgencyProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    agenciesResult = await _agencyProvider.get();
    var data = await _organizedTripProvider.get();
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Organized trips list"),
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
              value: selectedValue,
              hint: Text('Select agency'),
              onChanged: (newValue) async {
                setState(() {
                  selectedValue = newValue;
                });

                var filter = {
                  'agencyId': selectedValue,
                };

                if (selectedValue == null) {
                  filter['agencyId'] = null;
                }

                var data = await _organizedTripProvider.get(filter: filter);

                setState(() {
                  result = data;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: null, // Use null value for "All" option
                  child: Text('All agencies'),
                ),
                ...?agenciesResult?.result.map((item) {
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
                    builder: (context) => OrganizedTripDetailScreen(
                      organizedTrip: null,
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
          color: Colors.white, // Background color for the table
          child: DataTable(
            columnSpacing: 24.0, // Adjust column spacing as needed
            headingRowColor: WidgetStateColor.resolveWith(
                (states) => Colors.indigo), // Header row color
            dataRowColor: WidgetStateColor.resolveWith(
                (states) => Colors.white), // Row color
            columns: [
              DataColumn(
                label: Text(
                  'Trip name',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Agency',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Destination',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Contact Info',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
            ],
            rows: result?.result
                    .map((OrganizedTripModel e) => DataRow(
                          onSelectChanged: (selected) => {
                            if (selected == true)
                              {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrganizedTripDetailScreen(
                                      organizedTrip: e,
                                    ),
                                  ),
                                )
                              }
                          },
                          cells: [
                            DataCell(Text(e.tripName ?? "")),
                            DataCell(Text(e.agency?.name ?? "")),
                            DataCell(Text(e.destination ?? "")),
                            DataCell(Text(e.contactInfo ?? "")),
                          ],
                        ))
                    .toList() ??
                [],
          ),
        ),
      ),
    );
  }
}
