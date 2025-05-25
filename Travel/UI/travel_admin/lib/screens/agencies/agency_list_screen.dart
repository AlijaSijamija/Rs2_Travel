import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_admin/model/agency/agency.dart';
import 'package:travel_admin/model/search_result.dart';
import 'package:travel_admin/providers/agency_provider.dart';
import 'package:travel_admin/screens/agencies/agency_details_screen.dart';
import 'package:travel_admin/widgets/master_screen.dart';

class AgencyListScreen extends StatefulWidget {
  const AgencyListScreen({super.key});

  @override
  State<AgencyListScreen> createState() => _AgencyListScreenState();
  void functionThatSetsTheState() {}
}

class _AgencyListScreenState extends State<AgencyListScreen> {
  late AgencyProvider _agencyProvider;
  SearchResult<AgencyModel>? result;
  TextEditingController _nameController = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _agencyProvider = context.read<AgencyProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    var data = await _agencyProvider.get();
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Agency list"),
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
            child: TextField(
              decoration: InputDecoration(labelText: "Name"),
              controller: _nameController,
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                var data = await _agencyProvider.get(filter: {
                  'name': _nameController.text,
                });

                setState(() {
                  result = data;
                });
              },
              child: Text("Search")),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AgencyDetailScreen(
                      agencyModel: null,
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
                  'Name',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Web',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Contact',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
            ],
            rows: result?.result
                    .map((AgencyModel e) => DataRow(
                          onSelectChanged: (selected) => {
                            if (selected == true)
                              {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AgencyDetailScreen(
                                      agencyModel: e,
                                    ),
                                  ),
                                )
                              }
                          },
                          cells: [
                            DataCell(Text(e.name ?? "")),
                            DataCell(Text(e.web ?? "")),
                            DataCell(Text(e.contact ?? "")),
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
