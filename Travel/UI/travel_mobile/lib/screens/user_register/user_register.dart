import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:travel_mobile/model/account/account.dart';
import 'package:travel_mobile/providers/account_provider.dart';
import 'package:travel_mobile/screens/home/home_screen.dart';
import '../../widgets/master_screen.dart';

class UserRegisterScreen extends StatefulWidget {
  AccountModel? user;
  UserRegisterScreen({Key? key, this.user}) : super(key: key);

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenScreenState();
}

class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}

class _UserRegisterScreenScreenState extends State<UserRegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late AccountProvider _accountProvider;

  bool isLoading = true;
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

    _accountProvider = context.read<AccountProvider>();

    initForm();
  }

  Future initForm() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: SingleChildScrollView(
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
                              'userType': 2,
                              'email': formValue['email'],
                              'password': formValue['password'] ?? '',
                              'confirmPassword':
                                  formValue['confirmPassword'] ?? '',
                              'birthDate':
                                  formValue['birthDate'].toIso8601String(),
                              'userName': formValue['email'],
                            };
                            await _accountProvider.register(request);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Successful registration.'),
                              ),
                            );
                            Navigator.of(context).pop();
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
                      child: Text("Register")),
                )
              ],
            )
          ],
        ),
      ),
      title: this.widget.user?.fullName ?? "Register",
      showBackButton: true,
    );
  }

  Padding _buildForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FormBuilderTextField(
                          decoration:
                              const InputDecoration(labelText: "First name"),
                          name: "firstName",
                          validator: FormBuilderValidators.required(
                            errorText: 'First name is required',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FormBuilderTextField(
                          decoration:
                              const InputDecoration(labelText: "Last name"),
                          name: "lastName",
                          validator: FormBuilderValidators.required(
                            errorText: 'Last name is required',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FormBuilderTextField(
                          decoration: const InputDecoration(labelText: "Email"),
                          name: "email",
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: 'Email is required',
                            ),
                            FormBuilderValidators.email(
                              errorText: 'Please insert valid email format',
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FormBuilderTextField(
                          decoration: const InputDecoration(
                            labelText: "Phone number",
                            hintText: "+387 62 740 788 or +387 60 740 7888",
                          ),
                          name: "phoneNumber",
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'Phone number is required'),
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: double.infinity,
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
                                  alignment: AlignmentDirectional.center,
                                  value: item.value.toString(),
                                  child: Text(item.displayText),
                                ),
                              )
                              .toList(),
                          validator: FormBuilderValidators.required(
                            errorText: 'Gender is required',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FormBuilderDateTimePicker(
                      name: 'birthDate',
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                      ),
                      initialEntryMode: DatePickerEntryMode.calendar,
                      inputType: InputType.date,
                      format: DateFormat('dd-MM-yyyy'),
                      validator: FormBuilderValidators.required(
                        errorText: 'Date of Birth is required',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FormBuilderTextField(
                          decoration:
                              const InputDecoration(labelText: "Password"),
                          name: "password",
                          obscureText: true,
                          validator: (value) {
                            if (!isEditMode ||
                                (value != null && value.isNotEmpty)) {
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
                      SizedBox(
                        width: double.infinity,
                        child: FormBuilderTextField(
                          decoration: const InputDecoration(
                              labelText: "Confirm password"),
                          name: "confirmPassword",
                          obscureText: true,
                          validator: (value) {
                            if ((_formKey.currentState!.fields['password']
                                            ?.value !=
                                        null &&
                                    _formKey.currentState!.fields['password']
                                        ?.value.isNotEmpty) ||
                                !isEditMode) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm password is required';
                              }
                              if (value !=
                                  _formKey.currentState!.fields['password']
                                      ?.value) {
                                return 'Passwords do not match';
                              }
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
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
