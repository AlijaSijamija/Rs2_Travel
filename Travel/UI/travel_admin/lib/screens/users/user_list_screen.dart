import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_admin/model/account/account.dart';
import 'package:travel_admin/model/search_result.dart';
import 'package:travel_admin/providers/account_provider.dart';
import 'package:travel_admin/screens/booked_routes/booked_routes_screen.dart';
import 'package:travel_admin/screens/booked_trips/booked_trips_screen.dart';
import 'package:travel_admin/screens/users/user_details_screen.dart';
import 'package:travel_admin/widgets/master_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}

class _UserListScreenState extends State<UserListScreen> {
  late AccountProvider _accountProvider;
  SearchResult<AccountModel>? result;
  TextEditingController _nameController = new TextEditingController();
  String? selectedValue; // variable to store the selected value
  Timer? _debounce;
  List<DropdownItem> dropdownItems = [
    DropdownItem(0, 'All users'),
    DropdownItem(1, 'Admins'),
    DropdownItem(2, 'Passengers'),
  ];
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _accountProvider = context.read<AccountProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    var data = await _accountProvider.getAll();
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("User list"),
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
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: "First or last name"),
              controller: _nameController,
              onChanged: (value) {
                // cancel prethodni timer
                if (_debounce?.isActive ?? false) _debounce!.cancel();

                // novi timer sa delayom 500ms
                _debounce = Timer(Duration(milliseconds: 500), () async {
                  var data = await _accountProvider.getAll(filter: {
                    'fullName': _nameController.text,
                    'userTypes': selectedValue
                  });

                  setState(() {
                    result = data;
                  });
                });
              },
            ),
          ),
          Expanded(
            child: DropdownButton<String>(
              padding: EdgeInsets.only(top: 20.0, left: 5.0),
              value: selectedValue,
              hint: Text('Select user type'),
              onChanged: (newValue) async {
                setState(() {
                  selectedValue = newValue;
                });

                var data = await _accountProvider.getAll(filter: {
                  'fullName': _nameController.text,
                  'userTypes': selectedValue
                });

                setState(() {
                  result = data;
                });
              },
              items: dropdownItems.map((item) {
                return DropdownMenuItem<String>(
                  value: item.value.toString(),
                  child: Text(item.displayText),
                );
              }).toList(),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserDetailsScreen(user: null),
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
          color: Colors.white, // Background color for the table
          child: DataTable(
            columnSpacing: 24.0, // Adjust column spacing as needed
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.indigo),
            columns: [
              DataColumn(
                label: Text(
                  'First name',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Last name',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Email',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Phone number',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'User type',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
            ],
            rows: result?.result.map((AccountModel e) {
                  void onRowTap() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(user: e),
                      ),
                    );
                  }

                  return DataRow(
                    cells: [
                      DataCell(Text(e.firstName ?? ""), onTap: onRowTap),
                      DataCell(Text(e.lastName ?? ""), onTap: onRowTap),
                      DataCell(Text(e.email ?? ""), onTap: onRowTap),
                      DataCell(Text(e.phoneNumber ?? ""), onTap: onRowTap),
                      DataCell(Text(e.role ?? ""), onTap: onRowTap),
                      DataCell(
                        e.role?.toLowerCase() == 'admin'
                            ? const SizedBox.shrink()
                            : Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            BookedTripsScreen(userId: e.id!),
                                      ));
                                    },
                                    child: const Text("Booked trips"),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            BookedRoutesScreen(userId: e.id!),
                                      ));
                                    },
                                    child: const Text("Route tickets"),
                                  ),
                                ],
                              ),
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
