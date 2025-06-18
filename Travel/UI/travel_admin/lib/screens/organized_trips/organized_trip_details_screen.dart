import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:travel_admin/model/agency/agency.dart';
import 'package:travel_admin/model/organized_trip/organized_trip.dart';
import 'package:travel_admin/model/search_result.dart';
import 'package:travel_admin/model/trip_service/trip_service.dart';
import 'package:travel_admin/providers/agency_provider.dart';
import 'package:travel_admin/providers/organized_trip_provider.dart';
import 'package:travel_admin/providers/trip_service_provider.dart';
import 'package:travel_admin/screens/organized_trips/organized_trip_list_screen.dart';
import 'package:travel_admin/widgets/master_screen.dart';

class OrganizedTripDetailScreen extends StatefulWidget {
  OrganizedTripModel? organizedTrip;
  OrganizedTripDetailScreen({super.key, this.organizedTrip});

  @override
  State<OrganizedTripDetailScreen> createState() =>
      _OrganizedTripDetailScreenState();
}

class _OrganizedTripDetailScreenState extends State<OrganizedTripDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late OrganizedTripProvider _organizedTripProvider;
  late TripServiceProvider _tripServiceProvider;
  late AgencyProvider _agencyProvider;
  SearchResult<AgencyModel>? agenciesResult;
  SearchResult<TripServiceModel>? tripServicesResult;
  bool isLoading = true;
  List<String> _includedService = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'availableSeats': widget.organizedTrip?.availableSeats.toString(),
      'agencyId': widget.organizedTrip?.agencyId.toString(),
      'description': widget.organizedTrip?.description.toString(),
      'destination': widget.organizedTrip?.destination.toString(),
      'startDate': widget.organizedTrip?.startDate,
      'endDate': widget.organizedTrip?.endDate,
      'contactInfo': widget.organizedTrip?.contactInfo,
      'price': widget.organizedTrip?.price.toString(),
      'tripName': widget.organizedTrip?.tripName,
      'includedServices': widget.organizedTrip?.includedServices
              ?.map((service) => service.id.toString())
              .toList() ??
          [],
    };
    _includedService = (_initialValue['includedServices'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    _organizedTripProvider = context.read<OrganizedTripProvider>();
    _agencyProvider = context.read<AgencyProvider>();
    _tripServiceProvider = context.read<TripServiceProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future initForm() async {
    agenciesResult = await _agencyProvider.get();
    tripServicesResult = await _tripServiceProvider.get();
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
                          'availableSeats': formValue!['availableSeats'],
                          'agencyId': int.tryParse(formValue['agencyId']),
                          'description': formValue['description'],
                          'destination': formValue['destination'],
                          'startDate': formValue['startDate'].toIso8601String(),
                          'endDate': formValue['endDate'].toIso8601String(),
                          'contactInfo': formValue['contactInfo'],
                          'price': formValue['price'],
                          'tripName': formValue!['tripName'],
                          'includedServicesIds': formValue!['includedServices']
                        };
                        if (widget.organizedTrip == null) {
                          await _organizedTripProvider.insert(request);
                        } else {
                          await _organizedTripProvider.update(
                              widget.organizedTrip!.id!, request);
                        }

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const OrganizedTripListScreen()));
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
              if (widget.organizedTrip != null) ...[
                ElevatedButton(
                  onPressed: () {
                    // Show delete confirmation dialog here
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Delete"),
                          content: Text(
                              "Are you sure you want to delete this trip?"),
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
                                  if (widget.organizedTrip != null) {
                                    await _organizedTripProvider
                                        .delete(widget.organizedTrip!.id!);
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    Navigator.of(context).pop();
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrganizedTripListScreen(),
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
      title: widget.organizedTrip?.tripName ?? 'Organized trip details',
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
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderTextField(
                              decoration:
                                  InputDecoration(labelText: "Trip name"),
                              name: "tripName",
                              validator: FormBuilderValidators.required(
                                errorText: 'Trip name is required',
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderTextField(
                              decoration:
                                  InputDecoration(labelText: "Description"),
                              name: "description",
                              validator: FormBuilderValidators.required(
                                errorText: 'Description is required',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderTextField(
                              decoration:
                                  InputDecoration(labelText: "Destination"),
                              name: "destination",
                              validator: FormBuilderValidators.required(
                                errorText: 'Destination is required',
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderTextField(
                              decoration: InputDecoration(
                                  labelText: "Contact info (email)"),
                              name: "contactInfo",
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: 'Contact info is required',
                                ),
                                FormBuilderValidators.email(
                                  errorText: 'Please insert valid email format',
                                ),
                              ]),
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
                                  errorText: 'Agency is required'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderDateTimePicker(
                              name: 'startDate',
                              initialEntryMode: DatePickerEntryMode.calendar,
                              inputType: InputType.date,
                              decoration: InputDecoration(
                                labelText: 'Start date',
                                suffixIcon: Icon(Icons.access_time),
                              ),
                              validator: FormBuilderValidators.required(
                                  errorText: 'Start date is required'),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderDateTimePicker(
                              name: 'endDate',
                              initialEntryMode: DatePickerEntryMode.calendar,
                              inputType: InputType.date,
                              decoration: InputDecoration(
                                labelText: 'End date',
                                suffixIcon: Icon(Icons.access_time),
                              ),
                              validator: (val) {
                                final formState = _formKey.currentState;
                                final departure = formState
                                    ?.fields['startDate']?.value as DateTime?;
                                if (val == null) {
                                  return 'End date is required';
                                }
                                if (departure != null &&
                                    val.isBefore(departure)) {
                                  return 'End date must be after start date';
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
                            child: FormBuilderTextField(
                              decoration: InputDecoration(
                                labelText: "Number of seats",
                                hintText: "Enter a number between 1 and 200",
                              ),
                              name: "availableSeats",
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
                                FormBuilderValidators.max(200,
                                    errorText: 'Maximum number is 200'),
                              ]),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderTextField(
                              decoration: InputDecoration(
                                labelText: "Price in BAM",
                                hintText: "10.50",
                              ),
                              name: "price",
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
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderFilterChip(
                              name: 'includedServices',
                              decoration: InputDecoration(
                                  labelText: "Included services"),
                              initialValue: _includedService,
                              options: tripServicesResult!.result
                                  .map((service) =>
                                      FormBuilderChipOption<dynamic>(
                                        value: service.id.toString(),
                                        child: Text("${service.name}"),
                                      ))
                                  .toList(),
                              spacing: 8,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'At least one service must be selected';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _includedService = value
                                          ?.map((e) => e.toString())
                                          .toList() ??
                                      [];
                                });
                              },
                            ),
                          ),
                        ],
                      ),
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
