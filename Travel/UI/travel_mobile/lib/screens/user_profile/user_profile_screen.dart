import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/main.dart';
import 'package:travel_mobile/model/account/account.dart';
import 'package:travel_mobile/screens/home/home_screen.dart';
import 'package:travel_mobile/utils/util.dart';
import '../../providers/account_provider.dart';
import '../../widgets/master_screen.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _changePasswordKey = GlobalKey<FormBuilderState>();
  final _personalInfoKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AccountProvider _accountProvider;
  bool isLoading = true;
  dynamic currentUser = null;
  late AccountModel userProfile;
  List<DropdownItem> genders = [
    DropdownItem(1, 'Male'),
    DropdownItem(2, 'Female')
  ];

  @override
  void initState() {
    super.initState();
    _accountProvider = context.read<AccountProvider>();
    initForm();
  }

  Future initForm() async {
    currentUser = await _accountProvider.getCurrentUser();
    userProfile = await _accountProvider.userProfile(currentUser.nameid);
    setState(() {
      isLoading = false;
      _initialValue = {
        'firstName': userProfile?.firstName,
        'lastName': userProfile?.lastName,
        'phoneNumber': userProfile?.phoneNumber,
        'gender': userProfile?.gender.toString(),
        'email': userProfile?.email,
        'birthDate': userProfile?.birthDate,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "User Profile",
      showBackButton: true,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              if (!isLoading) _buildPersonalInfoForm(),
              if (!isLoading) _buildSavePersonalInfoButton(),
              if (!isLoading) _buildChangePasswordForm(),
              if (!isLoading) _buildChangePasswordButton(),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavePersonalInfoButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () async {
          if (_personalInfoKey.currentState?.validate() ?? false) {
            try {
              _personalInfoKey.currentState?.saveAndValidate();
              var formValue = _personalInfoKey.currentState?.value;
              var request = {
                'firstName': formValue!['firstName'],
                'lastName': formValue['lastName'],
                'phoneNumber': formValue['phoneNumber'],
                'gender': int.tryParse(formValue['gender']),
                'email': formValue['email'],
                'birthDate': formValue['birthDate'].toIso8601String(),
              };
              await _accountProvider.updateProfile(
                  currentUser!.nameid!, request);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profile successfully updated'),
                ),
              );
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomePageScreen()));
            } on Exception catch (e) {
              _showErrorDialog(e.toString());
            }
          }
        },
        child: Text("Save Personal Info"),
      ),
    );
  }

  Widget _buildChangePasswordButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () async {
          if (_changePasswordKey.currentState?.validate() ?? false) {
            try {
              _changePasswordKey.currentState?.saveAndValidate();
              var formValue = _changePasswordKey.currentState?.value;
              var currentPassword = formValue!['currentPassword'];
              var newPassword = formValue['newPassword'];
              await _accountProvider.changePassword(
                currentUser!.nameid!,
                {
                  'currentPassword': currentPassword,
                  'newPassword': newPassword,
                  'confirmPassword': newPassword,
                },
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('You have successfully changed your password.'),
                ),
              );
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomePageScreen()));
            } on Exception catch (e) {
              _showErrorDialog(e.toString());
            }
          }
        },
        child: Text("Change Password"),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          Authorization.token = null;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
          );
        },
        child: Text("Logout"),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  Widget _buildPersonalInfoForm() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: FormBuilder(
        key: _personalInfoKey,
        initialValue: _initialValue,
        autovalidateMode: AutovalidateMode.disabled,
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormBuilderTextField(
                  decoration: InputDecoration(labelText: "First name"),
                  name: "firstName",
                  validator: FormBuilderValidators.required(
                    errorText: 'First name is required',
                  ),
                ),
                SizedBox(height: 10),
                FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Last name"),
                  name: "lastName",
                  validator: FormBuilderValidators.required(
                    errorText: 'Last name is required',
                  ),
                ),
                SizedBox(height: 10),
                FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Email"),
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
                SizedBox(height: 10),
                FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Phone number"),
                  name: "phoneNumber",
                  validator: FormBuilderValidators.required(
                    errorText: 'Phone number is required',
                  ),
                ),
                SizedBox(height: 10),
                FormBuilderDropdown<String>(
                  name: 'gender',
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    hintText: 'Select gender',
                  ),
                  items: genders
                      .map(
                        (item) => DropdownMenuItem(
                          value: item.value.toString(),
                          child: Text(item.displayText),
                        ),
                      )
                      .toList(),
                  validator: FormBuilderValidators.required(
                    errorText: 'Gender is required',
                  ),
                ),
                SizedBox(height: 10),
                FormBuilderDateTimePicker(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordForm() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: FormBuilder(
        key: _changePasswordKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Current Password"),
                  name: "currentPassword",
                  obscureText: true,
                  validator: FormBuilderValidators.required(
                    errorText: 'Current Password is required',
                  ),
                ),
                SizedBox(height: 10),
                FormBuilderTextField(
                  decoration: InputDecoration(labelText: "New Password"),
                  name: "newPassword",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New Password is required';
                    }
                    if (value.length < 6) {
                      return 'New Password must be at least 6 characters';
                    }
                    if (!value.contains(RegExp(r'[a-z]'))) {
                      return 'Must contain at least one lowercase letter';
                    }
                    if (!value.contains(RegExp(r'[A-Z]'))) {
                      return 'Must contain at least one uppercase letter';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Repeat Password"),
                  name: "repeatPassword",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Repeat Password is required';
                    }
                    if (value !=
                        _changePasswordKey
                            .currentState?.fields['newPassword']?.value) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}
