import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:travel_admin/model/account/account.dart';
import 'package:travel_admin/model/city/city.dart';
import 'package:travel_admin/model/enums/user_type.dart';
import 'package:travel_admin/model/search_result.dart';
import 'package:travel_admin/providers/city_provider.dart';
import 'package:travel_admin/screens/users/user_list_screen.dart';
import '../../providers/account_provider.dart';
import '../../widgets/master_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  AccountModel? user;
  UserDetailsScreen({Key? key, this.user}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AccountProvider _accountProvider;
  late CityProvider _cityProvider;

  bool isLoading = true;
  dynamic currentUser = null;
  SearchResult<CityModel>? citiesResult;
  List<DropdownItem> roles = [
    DropdownItem(1, 'Admin'),
    DropdownItem(2, 'Passenger'),
  ];
  List<DropdownItem> genders = [
    DropdownItem(1, 'Male'),
    DropdownItem(2, 'Female')
  ];
  bool isEditMode = false;

  @override
  void initState() {
    if (widget.user != null) {
      isEditMode = true;
    }
    super.initState();
    _initialValue = {
      'firstName': widget.user?.firstName,
      'lastName': widget.user?.lastName,
      'phoneNumber': widget.user?.phoneNumber,
      'gender': widget.user?.gender.toString(),
      'userType': widget.user?.userType.toString(),
      'email': widget.user?.email,
      'password': widget.user?.password,
      'confirmPassword': widget.user?.confirmPassword,
      'birthDate': widget.user?.birthDate,
      'cityId': widget.user?.cityId?.toString(),
    };

    _accountProvider = context.read<AccountProvider>();
    _cityProvider = context.read<CityProvider>();

    initForm();
  }

  Future initForm() async {
    currentUser = await _accountProvider.getCurrentUser();
    citiesResult = await _cityProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
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
                            'firstName': formValue!['firstName'],
                            'lastName': formValue['lastName'],
                            'phoneNumber': formValue['phoneNumber'],
                            'gender': int.tryParse(formValue['gender']),
                            'userType': int.tryParse(formValue['userType']),
                            'email': formValue['email'],
                            'password': formValue['password'] ?? '',
                            'confirmPassword':
                                formValue['confirmPassword'] ?? '',
                            'birthDate':
                                formValue['birthDate'].toIso8601String(),
                            'userName': formValue['email'],
                            'cityId': int.tryParse(formValue['cityId'])
                          };
                          if (widget.user == null) {
                            await _accountProvider.register(request);
                          } else {
                            await _accountProvider.updateUser(
                                widget.user!.id!, request);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.user == null
                                    ? 'User successfully created'
                                    : 'User successfully updated',
                              ),
                            ),
                          );
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const UserListScreen()));
                        } on Exception catch (e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Error"),
                                    content: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("OK"))
                                    ],
                                  ));
                        }
                      }
                    },
                    child: Text("Save")),
              ),
              if (widget.user != null && widget.user?.userType != 1) ...[
                ElevatedButton(
                  onPressed: () {
                    // Show delete confirmation dialog here
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Delete"),
                          content: Text(
                              "Are you sure you want to delete this user?"),
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
                                  if (widget.user != null) {
                                    await _accountProvider
                                        .remove(widget.user!.id!);
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    Navigator.of(context).pop();
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserListScreen(),
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
          )
        ],
      ),
      title: this.widget.user?.fullName ?? "User details",
      showBackButton: true,
    );
  }

  Padding _buildForm() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        autovalidateMode: AutovalidateMode.disabled,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/images/image2.jpg",
                            height: 300,
                            width: 300,
                          ),
                        )),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                decoration:
                                    InputDecoration(labelText: "First name"),
                                name: "firstName",
                                validator: FormBuilderValidators.required(
                                  errorText: 'First name is required',
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: FormBuilderTextField(
                                decoration:
                                    InputDecoration(labelText: "Last name"),
                                name: "lastName",
                                validator: FormBuilderValidators.required(
                                  errorText: 'Last name is required',
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
                                decoration: InputDecoration(labelText: "Email"),
                                name: "email",
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: 'Email is required',
                                  ),
                                  FormBuilderValidators.email(
                                    errorText:
                                        'Please insert valid email format',
                                  ),
                                ]),
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(width: 10),
                            Expanded(
                              child: FormBuilderDropdown<String>(
                                name: 'cityId',
                                decoration: InputDecoration(
                                  labelText: 'City',
                                  suffix: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _formKey.currentState!.fields['cityId']
                                          ?.reset();
                                    },
                                  ),
                                  hintText: 'Select city',
                                ),
                                items: citiesResult?.result
                                        .map(
                                          (item) => DropdownMenuItem(
                                            alignment:
                                                AlignmentDirectional.center,
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
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                decoration: InputDecoration(
                                  labelText: "Phone number",
                                  hintText:
                                      "+387 62 740 788 or +387 60 740 7888",
                                ),
                                name: "phoneNumber",
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: 'Phone number is required'),
                                  (value) {
                                    if (value == null || value.isEmpty) {
                                      return null;
                                    }
                                    final regex = RegExp(
                                        r'^\+387\s?(62\s?\d{3}\s?\d{3}|61\s?\d{3}\s?\d{3}|60\s?\d{3}\s?\d{4})$');
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
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderDropdown<String>(
                                name: 'userType',
                                decoration: InputDecoration(
                                  labelText: 'User type',
                                  suffix: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _formKey.currentState!.fields['userType']
                                          ?.reset();
                                    },
                                  ),
                                  hintText: 'Select user role section',
                                ),
                                items: roles
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
                                  errorText: 'Role is required',
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: FormBuilderDropdown<String>(
                                name: 'gender',
                                decoration: InputDecoration(
                                  labelText: 'Gender',
                                  suffix: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _formKey.currentState!.fields['gender']
                                          ?.reset();
                                    },
                                  ),
                                  hintText: 'Select gender',
                                ),
                                items: genders
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
                                  errorText: 'Gender is required',
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
                                    InputDecoration(labelText: "Password"),
                                name: "password",
                                obscureText: true,
                                validator: (value) {
                                  if (!isEditMode ||
                                      value != null && value.isNotEmpty) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    if (!value.contains(RegExp(r'[a-z]'))) {
                                      return 'Password must contain at least one lowercase letter';
                                    }
                                    if (!value.contains(RegExp(r'[A-Z]'))) {
                                      return 'Password must contain at least one uppercase letter';
                                    }
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: FormBuilderTextField(
                                decoration: InputDecoration(
                                    labelText: "Confirm password"),
                                name: "confirmPassword",
                                obscureText: true,
                                validator: (value) {
                                  if ((_formKey.currentState!.fields['password']
                                                  ?.value !=
                                              null &&
                                          _formKey
                                              .currentState!
                                              .fields['password']
                                              ?.value
                                              .isNotEmpty) ||
                                      !isEditMode) {
                                    if (value == null || value.isEmpty) {
                                      return 'Confirm password is required';
                                    }
                                    if (value !=
                                        _formKey.currentState!
                                            .fields['password']?.value) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  }
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
                                name: 'birthDate',
                                decoration: InputDecoration(
                                  labelText: 'Date of Birth',
                                ),
                                initialEntryMode: DatePickerEntryMode.calendar,
                                inputType: InputType.date,
                                format: DateFormat('dd-MM-yyyy'),
                                validator: FormBuilderValidators.required(
                                  errorText: 'Date of Birth is required',
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
