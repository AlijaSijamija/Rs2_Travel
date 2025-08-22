import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_admin/model/agency/agency.dart';
import 'package:travel_admin/model/city/city.dart';
import 'package:travel_admin/model/route/route.dart';
import 'package:travel_admin/model/search_result.dart';
import 'package:travel_admin/providers/account_provider.dart';
import 'package:travel_admin/providers/agency_provider.dart';
import 'package:travel_admin/providers/city_provider.dart';
import 'package:travel_admin/providers/route_provider.dart';
import 'package:travel_admin/screens/routes/route_list_screen.dart';
import 'package:travel_admin/widgets/master_screen.dart';

class RouteDetailScreen extends StatefulWidget {
  RouteModel? route;
  RouteDetailScreen({super.key, this.route});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late RouteProvider _routeProvider;
  late AgencyProvider _agencyProvider;
  late CityProvider _cityProvider;
  late AccountProvider _accountProvider;
  SearchResult<AgencyModel>? agenciesResult;
  SearchResult<CityModel>? citiesResult;
  bool isLoading = true;
  dynamic currentUser = null;
  List<DropdownItem> busTypes = [
    DropdownItem(1, 'Mini'),
    DropdownItem(2, 'Midi'),
    DropdownItem(3, 'Standard'),
    DropdownItem(4, 'Luxury')
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'numberOfSeats': widget.route?.numberOfSeats.toString(),
      'adminId': widget.route?.adminId.toString(),
      'childPrice': widget.route?.childPrice.toString(),
      'adultPrice': widget.route?.adultPrice.toString(),
      'toCityId': widget.route?.toCityId.toString(),
      'fromCityId': widget.route?.fromCityId.toString(),
      'travelTime': parseTravelTime(widget.route?.travelTime),
      'agencyId': widget.route?.agencyId.toString(),
      'arrivalTime': parseTimeSpanToDateTime(widget.route?.arrivalTime),
      'departureTime': parseTimeSpanToDateTime(widget.route?.departureTime),
      'validFrom': widget.route?.validFrom,
      'validTo': widget.route?.validTo,
      'busType': widget.route?.busType.toString()
    };
    _routeProvider = context.read<RouteProvider>();
    _agencyProvider = context.read<AgencyProvider>();
    _cityProvider = context.read<CityProvider>();
    _accountProvider = context.read<AccountProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future initForm() async {
    agenciesResult = await _agencyProvider.get();
    citiesResult = await _cityProvider.get();
    currentUser = await _accountProvider.getCurrentUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      // ignore: sort_child_properties_last
      child: Column(
        children: [
          isLoading ? Container() : _buildForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        _formKey.currentState?.saveAndValidate();
                        var formValue = _formKey.currentState?.value;
                        var request = {
                          'adminId': this.currentUser.nameid,
                          'travelTime': formValue!['travelTime'],
                          'agencyId': int.tryParse(formValue['agencyId']),
                          'arrivalTime':
                              formatTimeOnly(formValue['arrivalTime']),
                          'departureTime':
                              formatTimeOnly(formValue['departureTime']),
                          'fromCityId': int.tryParse(formValue['fromCityId']),
                          'numberOfSeats': formValue!['numberOfSeats'],
                          'childPrice': formValue['childPrice'],
                          'adultPrice': formValue['adultPrice'],
                          'toCityId': int.tryParse(formValue['toCityId']),
                          'validFrom': formValue['validFrom'].toIso8601String(),
                          'validTo': formValue['validTo'].toIso8601String(),
                          'busType': int.tryParse(formValue['busType']),
                        };
                        if (widget.route == null) {
                          await _routeProvider.insert(request);
                        } else {
                          await _routeProvider.update(
                              widget.route!.id!, request);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.route == null
                                  ? 'Route successfully created'
                                  : 'Route successfully updated',
                            ),
                          ),
                        );

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const RouteListScreen()));
                      } on Exception catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Error"),
                            content: Text(e.toString()),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  child: Text("Save"),
                ),
              ),
              if (widget.route != null) ...[
                ElevatedButton(
                  onPressed: () {
                    // Show delete confirmation dialog here
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Delete"),
                          content: Text(
                              "Are you sure you want to delete this route?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                // Add delete logic here
                                try {
                                  if (widget.route != null) {
                                    await _routeProvider
                                        .delete(widget.route!.id!);
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    Navigator.of(context).pop();
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RouteListScreen(),
                                      ),
                                    );
                                  }
                                } on Exception catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Text("Error"),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Colors.white, //change background color of button
                    backgroundColor: Colors.red, // Set button color to red
                  ),
                  child: Text("Delete"),
                ),
              ],
            ],
          ),
        ],
      ),
      title: widget.route != null
          ? '${widget.route!.fromCity?.name} -> ${widget.route!.toCity?.name}'
          : 'Route details',
      showBackButton: true,
    );
  }

  Padding _buildForm() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0), // Adjust the top margin as needed
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        autovalidateMode: AutovalidateMode.disabled,
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1000),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Image.asset(
                      "assets/images/image2.jpg",
                      height: 300,
                      width: 300,
                    ),
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormBuilderField(
                        name: 'adminId',
                        builder: (FormFieldState<dynamic> field) {
                          return SizedBox(
                            height: 0,
                            width: 0,
                            child: TextFormField(
                              initialValue: this.currentUser != null
                                  ? this.currentUser?.nameid
                                  : '',
                              style: TextStyle(color: Colors.transparent),
                              decoration:
                                  InputDecoration.collapsed(hintText: ''),
                              onChanged: (val) {
                                field.didChange(this.currentUser.nameid);
                              },
                            ),
                          );
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderDropdown<String>(
                              name: 'fromCityId',
                              decoration: InputDecoration(
                                labelText: 'From city',
                                suffix: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _formKey.currentState!.fields['fromCityId']
                                        ?.reset();
                                  },
                                ),
                                hintText: 'Select city',
                              ),
                              items: citiesResult?.result
                                      .map((item) => DropdownMenuItem(
                                            alignment:
                                                AlignmentDirectional.center,
                                            value: item.id.toString(),
                                            child: Text(item.name ?? ""),
                                          ))
                                      .toList() ??
                                  [],
                              validator: FormBuilderValidators.required(
                                  errorText: 'From city is required'),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderDropdown<String>(
                              name: 'toCityId',
                              decoration: InputDecoration(
                                labelText: 'To city',
                                suffix: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _formKey.currentState!.fields['toCityId']
                                        ?.reset();
                                  },
                                ),
                                hintText: 'To city',
                              ),
                              items: citiesResult?.result
                                      .map((item) => DropdownMenuItem(
                                            alignment:
                                                AlignmentDirectional.center,
                                            value: item.id.toString(),
                                            child: Text(item.name ?? ""),
                                          ))
                                      .toList() ??
                                  [],
                              validator: FormBuilderValidators.required(
                                  errorText: 'To city is required'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderDropdown<String>(
                              name: 'agencyId',
                              decoration: InputDecoration(
                                labelText: 'Agency',
                                suffix: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _formKey.currentState!.fields['agencyId']
                                        ?.reset();
                                  },
                                ),
                                hintText: 'Agency',
                              ),
                              items: agenciesResult?.result
                                      .map((item) => DropdownMenuItem(
                                            alignment:
                                                AlignmentDirectional.center,
                                            value: item.id.toString(),
                                            child: Text(item.name ?? ""),
                                          ))
                                      .toList() ??
                                  [],
                              validator: FormBuilderValidators.required(
                                  errorText: 'To city is required'),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderTextField(
                              decoration: InputDecoration(
                                labelText: "Adult price in BAM",
                                hintText: "10.50",
                              ),
                              name: "adultPrice",
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'Price is required'),
                                FormBuilderValidators.numeric(
                                    errorText: 'Enter a valid price'),
                                (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Price is required';
                                  }
                                  final parsed = double.tryParse(
                                      value.replaceAll(',', '.'));
                                  if (parsed == null) {
                                    return 'Enter a valid number';
                                  }
                                  if (parsed == 0.0) {
                                    return 'Price cannot be zero';
                                  }
                                  if (parsed >= 10000) {
                                    return 'Maximum 4 digits before decimal';
                                  }
                                  return null;
                                },
                              ]),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderTextField(
                              decoration: InputDecoration(
                                labelText: "Child price in BAM",
                                hintText: "10.50",
                              ),
                              name: "childPrice",
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'Price is required'),
                                FormBuilderValidators.numeric(
                                    errorText: 'Enter a valid price'),
                                (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Price is required';
                                  }
                                  final parsed = double.tryParse(
                                      value.replaceAll(',', '.'));
                                  if (parsed == null) {
                                    return 'Enter a valid number';
                                  }
                                  if (parsed == 0.0) {
                                    return 'Price cannot be zero';
                                  }
                                  if (parsed >= 10000) {
                                    return 'Maximum 4 digits before decimal';
                                  }
                                  return null;
                                },
                              ]),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}')),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderTextField(
                              name: "travelTime",
                              decoration: InputDecoration(
                                labelText: "Travel time",
                                hintText: "HH:mm",
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                _TimeInputFormatter(), // custom formatter
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Travel time is required';
                                } else if (!RegExp(
                                        r'^(0?[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$')
                                    .hasMatch(value)) {
                                  return 'Enter a valid time in HH:mm format';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderDateTimePicker(
                              name: 'departureTime',
                              initialEntryMode: DatePickerEntryMode.calendar,
                              inputType: InputType.time,
                              decoration: InputDecoration(
                                labelText: 'Departure Time',
                                suffixIcon: Icon(Icons.access_time),
                              ),
                              validator: FormBuilderValidators.required(
                                  errorText: 'Departure time is required'),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderDateTimePicker(
                              name: 'arrivalTime',
                              initialEntryMode: DatePickerEntryMode.calendar,
                              inputType: InputType.time,
                              decoration: InputDecoration(
                                labelText: 'Arrival Time',
                                suffixIcon: Icon(Icons.access_time),
                              ),
                              validator: (val) {
                                final formState = _formKey.currentState;
                                final departure = formState
                                    ?.fields['departureTime']
                                    ?.value as DateTime?;
                                if (val == null) {
                                  return 'Arrival time is required';
                                }
                                if (departure != null &&
                                    val.isBefore(departure)) {
                                  return 'Arrival time must be after departure time';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderDateTimePicker(
                              name: 'validFrom',
                              decoration: InputDecoration(
                                labelText: 'Valid from',
                              ),
                              initialEntryMode: DatePickerEntryMode.calendar,
                              inputType: InputType.date,
                              format: DateFormat('dd-MM-yyyy'),
                              validator: FormBuilderValidators.required(
                                errorText: 'Valid from is required',
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderDateTimePicker(
                              name: 'validTo',
                              decoration: InputDecoration(
                                labelText: 'Valid to',
                              ),
                              initialEntryMode: DatePickerEntryMode.calendar,
                              inputType: InputType.date,
                              format: DateFormat('dd-MM-yyyy'),
                              validator: FormBuilderValidators.required(
                                errorText: 'Valid to is required',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderTextField(
                              decoration: InputDecoration(
                                labelText: "Number of seats",
                                hintText: "Enter a number between 1 and 70",
                              ),
                              name: "numberOfSeats",
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: 'Number of seats is required',
                                ),
                                FormBuilderValidators.integer(
                                  errorText:
                                      'Please enter a valid whole number',
                                ),
                                FormBuilderValidators.min(1,
                                    errorText: 'Minimum number is 1'),
                                FormBuilderValidators.max(70,
                                    errorText: 'Maximum number is 70'),
                              ]),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: FormBuilderDropdown<String>(
                              name: 'busType',
                              decoration: InputDecoration(
                                labelText: 'Bus type',
                                suffix: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _formKey.currentState!.fields['busType']
                                        ?.reset();
                                  },
                                ),
                                hintText: 'Select bus type',
                              ),
                              items: busTypes
                                      .map(
                                        (item) => DropdownMenuItem(
                                          alignment:
                                              AlignmentDirectional.center,
                                          value: item.value.toString(),
                                          child: Text(item.displayText),
                                        ),
                                      )
                                      .toList() ??
                                  [],
                              validator: FormBuilderValidators.required(
                                errorText: 'Bus type is required',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String formatTimeOnly(DateTime? time) {
  if (time == null) return '';
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
}

DateTime? parseTimeSpanToDateTime(String? timeSpan) {
  if (timeSpan == null) return null;
  List<String> parts = timeSpan.split(':');
  if (parts.length != 3) return null;

  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = int.parse(parts[2]);

  return DateTime(0, 1, 1, hours, minutes, seconds);
}

class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String newText = '';

    if (digitsOnly.length >= 3) {
      newText = digitsOnly.substring(0, 2) + ':' + digitsOnly.substring(2);
    } else {
      newText = digitsOnly;
    }

    if (newText.length > 5) {
      newText = newText.substring(0, 5);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

String parseTravelTime(String? travelTime) {
  if (travelTime == null) return '';
  final regex = RegExp(r'(\d+)h (\d+)m');
  final match = regex.firstMatch(travelTime);
  if (match != null) {
    final hours = match.group(1)!.padLeft(2, '0');
    final minutes = match.group(2)!.padLeft(2, '0');
    return '$hours:$minutes';
  }
  return travelTime; // fallback
}
