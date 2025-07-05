import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_admin/model/notification/notification.dart';
import 'package:travel_admin/model/search_result.dart';
import 'package:travel_admin/model/section/section.dart'; // import za SectionModel
import 'package:travel_admin/providers/notification_provider.dart';
import 'package:travel_admin/providers/section_provider.dart'; // import za SectionProvider
import 'package:travel_admin/screens/notifications/notification_details_screen.dart';
import 'package:travel_admin/widgets/master_screen.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  late NotificationProvider _notificationProvider;
  late SectionProvider _sectionProvider;

  SearchResult<NotificationModel>? result;
  List<SectionModel>? sections;
  String? selectedSectionId;

  TextEditingController _headingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notificationProvider = context.read<NotificationProvider>();
    _sectionProvider = context.read<SectionProvider>();
    _loadSections();
    _loadData();
  }

  Future<void> _loadSections() async {
    var sectionsData = await _sectionProvider.get();
    setState(() {
      sections = sectionsData.result;
    });
  }

  Future<void> _loadData() async {
    var filter = <String, dynamic>{
      if (_headingController.text.isNotEmpty)
        'heading': _headingController.text,
      if (selectedSectionId != null) 'sectionId': selectedSectionId,
    };

    var data = await _notificationProvider.get(filter: filter);
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Notification list"),
      child: Container(
        child: Column(
          children: [
            _buildSearch(),
            _buildDataListView(),
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
            child: TextField(
              decoration: InputDecoration(labelText: "Heading"),
              controller: _headingController,
            ),
          ),
          SizedBox(width: 12),
          DropdownButton<String>(
            value: selectedSectionId,
            hint: Text("Select Section"),
            onChanged: (newValue) async {
              setState(() {
                selectedSectionId = newValue;
              });
              await _loadData();
            },
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text("All Sections"),
              ),
              ...?sections?.map(
                (section) => DropdownMenuItem<String>(
                  value: section.id.toString(),
                  child: Text(section.name ?? ""),
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              _loadData();
            },
            child: Text("Search"),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      NotificationDetailScreen(notification: null),
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
        scrollDirection: Axis.horizontal,
        child: Container(
          color: Colors.white,
          child: DataTable(
            columnSpacing: 32.0,
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.indigo),
            dataRowColor:
                MaterialStateColor.resolveWith((states) => Colors.white),
            columns: [
              DataColumn(
                label: Text(
                  'Heading',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Section',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Content',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
            ],
            rows: result?.result.map((e) {
                  void onRowTap() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NotificationDetailScreen(notification: e),
                      ),
                    );
                  }

                  return DataRow(
                    cells: [
                      DataCell(
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Text(
                            e.heading ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        onTap: onRowTap,
                      ),
                      DataCell(
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 150),
                          child: Text(
                            e.section?.name.toString() ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        onTap: onRowTap,
                      ),
                      DataCell(
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 300),
                          child: Text(
                            e.content ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        onTap: onRowTap,
                      ),
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
