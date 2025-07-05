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
}

class _OrganizedTripListScreenState extends State<OrganizedTripListScreen> {
  late OrganizedTripProvider _organizedTripProvider;
  SearchResult<OrganizedTripModel>? result;
  late AgencyProvider _agencyProvider;
  SearchResult<AgencyModel>? agenciesResult;
  String? selectedValue;

  int currentPage = 1;
  final int pageSize = 10;

  @override
  void initState() {
    super.initState();
    _organizedTripProvider = context.read<OrganizedTripProvider>();
    _agencyProvider = context.read<AgencyProvider>();
    _loadData();
  }

  Future<void> _loadData({int? page}) async {
    agenciesResult ??= await _agencyProvider.get();

    final filter = <String, dynamic>{
      if (selectedValue != null) 'agencyId': selectedValue,
      'page': page ?? currentPage,
      'pageSize': pageSize,
    };

    final data = await _organizedTripProvider.get(filter: filter);

    setState(() {
      result = data;
      if (page != null) currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalItems = result?.count ?? 0;
    final int totalPages = (totalItems / pageSize).ceil();

    return MasterScreenWidget(
      title_widget: Text("Organized trips list"),
      child: Container(
        child: Column(
          children: [
            _buildSearch(),
            _buildDataListView(),
            _buildPaginationControls(totalPages),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text('Select agency'),
              onChanged: (newValue) {
                setState(() {
                  selectedValue = newValue;
                  currentPage = 1; // reset page on filter change
                });
                _loadData(page: currentPage);
              },
              items: [
                DropdownMenuItem<String>(
                  value: null,
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
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrganizedTripDetailScreen(
                    organizedTrip: null,
                  ),
                ),
              );
            },
            child: Text("Add new"),
          ),
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
            rows: result?.result.map((e) {
                  return DataRow(
                    cells: [
                      DataCell(Text(e.tripName ?? ""),
                          onTap: () => _openDetail(e)),
                      DataCell(Text(e.agency?.name ?? ""),
                          onTap: () => _openDetail(e)),
                      DataCell(Text(e.destination ?? ""),
                          onTap: () => _openDetail(e)),
                      DataCell(Text(e.contactInfo ?? ""),
                          onTap: () => _openDetail(e)),
                    ],
                  );
                }).toList() ??
                [],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed:
                currentPage > 1 ? () => _loadData(page: currentPage - 1) : null,
            child: Text('Previous'),
          ),
          SizedBox(width: 20),
          Text('Page $currentPage of $totalPages'),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: currentPage < totalPages
                ? () => _loadData(page: currentPage + 1)
                : null,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }

  void _openDetail(OrganizedTripModel trip) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrganizedTripDetailScreen(
          organizedTrip: trip,
        ),
      ),
    );
  }
}
