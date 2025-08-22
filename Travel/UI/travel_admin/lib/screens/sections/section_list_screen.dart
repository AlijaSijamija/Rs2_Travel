import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_admin/model/search_result.dart';
import 'package:travel_admin/model/section/section.dart';
import 'package:travel_admin/providers/section_provider.dart';
import 'package:travel_admin/screens/sections/section_details_screen.dart';
import 'package:travel_admin/widgets/master_screen.dart';

class SectionListScreen extends StatefulWidget {
  const SectionListScreen({super.key});

  @override
  State<SectionListScreen> createState() => _SectionListScreenState();
  void functionThatSetsTheState() {}
}

class _SectionListScreenState extends State<SectionListScreen> {
  late SectionProvider _sectionProvider;
  SearchResult<SectionModel>? result;
  TextEditingController _nameController = TextEditingController();

  int currentPage = 1;
  final int pageSize = 10; // koliko elemenata po stranici
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    _sectionProvider = context.read<SectionProvider>();
    _loadData();
  }

  Future<void> _loadData({int? page}) async {
    var filter = {
      'name': _nameController.text,
      'page': page ?? currentPage,
      'pageSize': pageSize,
    };

    var data = await _sectionProvider.get(filter: filter);

    setState(() {
      result = data;
      if (page != null) currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Section list"),
      child: Container(
        child: Column(
          children: [
            _buildSearch(),
            _buildDataListView(),
            _buildPaginationControls(),
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
              decoration: InputDecoration(labelText: "Name"),
              controller: _nameController,
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(Duration(milliseconds: 500), () async {
                  currentPage = 1;
                  await _loadData(page: currentPage);
                });
              },
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SectionDetailScreen(sectionModel: null),
                ),
              );
            },
            child: Text("Add new"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
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
                  'Name',
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
                            SectionDetailScreen(sectionModel: e),
                      ),
                    );
                  }

                  return DataRow(
                    cells: [
                      DataCell(Text(e.name ?? ""), onTap: onRowTap),
                    ],
                  );
                }).toList() ??
                [],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    final int totalItems = result?.count ?? 0;
    final int totalPages = (totalItems / pageSize).ceil();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: currentPage > 1
                ? () {
                    _loadData(page: currentPage - 1);
                  }
                : null,
            child: Text('Previous'),
          ),
          SizedBox(width: 20),
          Text('Page $currentPage of $totalPages'),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: currentPage < totalPages
                ? () {
                    _loadData(page: currentPage + 1);
                  }
                : null,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}
