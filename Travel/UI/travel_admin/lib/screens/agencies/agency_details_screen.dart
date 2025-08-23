import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:travel_admin/model/agency/agency.dart';
import 'package:travel_admin/model/city/city.dart';
import 'package:travel_admin/model/search_result.dart';
import 'package:travel_admin/providers/account_provider.dart';
import 'package:travel_admin/providers/agency_provider.dart';
import 'package:travel_admin/providers/city_provider.dart';
import 'package:travel_admin/screens/agencies/agency_list_screen.dart';
import 'package:travel_admin/widgets/master_screen.dart';

class AgencyDetailScreen extends StatefulWidget {
  AgencyModel? agencyModel;
  AgencyDetailScreen({super.key, this.agencyModel});

  @override
  State<AgencyDetailScreen> createState() => _AgencyDetailScreenState();
}

class _AgencyDetailScreenState extends State<AgencyDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AgencyProvider _agencyProvider;
  late CityProvider _cityProvider;
  late AccountProvider _accountProvider;
  SearchResult<CityModel>? citiesResult;
  bool isLoading = true;
  dynamic currentUser = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'name': widget.agencyModel?.name,
      'web': widget.agencyModel?.web,
      'contact': widget.agencyModel?.contact,
      'cityId': widget.agencyModel?.cityId?.toString(),
      'adminId': widget.agencyModel?.adminId.toString()
    };

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
                        _formKey.currentState
                            ?.patchValue({'adminId': this.currentUser.nameid});
                        _formKey.currentState?.saveAndValidate();

                        if (widget.agencyModel == null) {
                          await _agencyProvider
                              .insert(_formKey.currentState?.value);
                        } else {
                          await _agencyProvider.update(widget.agencyModel!.id!,
                              _formKey.currentState?.value);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.agencyModel == null
                                  ? 'Agency successfully created'
                                  : 'Agency successfully updated',
                            ),
                          ),
                        );
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AgencyListScreen()));
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
              if (widget.agencyModel != null) ...[
                ElevatedButton(
                  onPressed: () {
                    // Show delete confirmation dialog here
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Delete"),
                          content: Text(
                              "Are you sure you want to delete this agency?"),
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
                                  if (widget.agencyModel != null) {
                                    await _agencyProvider
                                        .delete(widget.agencyModel!.id!);
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    Navigator.of(context).pop();
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AgencyListScreen(),
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
      title: this.widget.agencyModel?.name ?? "Agency details",
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
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Name"),
                        name: "name",
                        validator: FormBuilderValidators.required(
                          errorText: 'Name is required',
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(
                          labelText: "Contact",
                          hintText: "+387 62 740 788 or +387 60 740 7888",
                        ),
                        name: "contact",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Contact is required'),
                          (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            final regex =
                                RegExp(r'^(?:\+|00)?\d(?:\s?\d){5,14}$');
                            if (!regex.hasMatch(value)) {
                              return 'Enter a valid phone number in the format +387 62 740 788 or +387 60 740 7888';
                            }
                            return null;
                          },
                        ]),
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9+\s]')),
                        ],
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Web"),
                        name: "web",
                        validator: FormBuilderValidators.required(
                          errorText: 'Web is required',
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderDropdown<String>(
                        name: 'cityId',
                        decoration: InputDecoration(
                          labelText: 'City',
                          suffix: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _formKey.currentState!.fields['cityId']?.reset();
                            },
                          ),
                          hintText: 'Select city',
                        ),
                        items: citiesResult?.result
                                .map(
                                  (item) => DropdownMenuItem(
                                    alignment: AlignmentDirectional.center,
                                    value: item.id.toString(),
                                    child: Text(item.name ?? ""),
                                  ),
                                )
                                .toList() ??
                            [],
                        validator: FormBuilderValidators.required(
                          errorText: 'City is required',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
