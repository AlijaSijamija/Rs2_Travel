import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:travel_admin/model/city/city.dart';
import 'package:travel_admin/providers/city_provider.dart';
import 'package:travel_admin/screens/cities/city_list_screen.dart';
import 'package:travel_admin/widgets/master_screen.dart';

class CityDetailScreen extends StatefulWidget {
  CityModel? cityModel;
  CityDetailScreen({super.key, this.cityModel});

  @override
  State<CityDetailScreen> createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends State<CityDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late CityProvider _cityProvider;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'name': widget.cityModel?.name,
    };
    _cityProvider = context.read<CityProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future initForm() async {
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
                        var request = {
                          'name':
                              _formKey.currentState?.instantValue.values.first,
                        };
                        if (widget.cityModel == null) {
                          await _cityProvider.insert(request);
                        } else {
                          await _cityProvider.update(
                              widget.cityModel!.id!, request);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.cityModel == null
                                  ? 'City successfully created'
                                  : 'City successfully updated',
                            ),
                          ),
                        );
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CityListScreen()));
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
              if (widget.cityModel != null) ...[
                ElevatedButton(
                  onPressed: () {
                    // Show delete confirmation dialog here
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Delete"),
                          content: Text(
                              "Are you sure you want to delete this city?"),
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
                                  if (widget.cityModel != null) {
                                    await _cityProvider
                                        .delete(widget.cityModel!.id!);
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    Navigator.of(context).pop();
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CityListScreen(),
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
      title: this.widget.cityModel?.name ?? "City details",
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
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Name"),
                        name: "name",
                        validator: FormBuilderValidators.required(
                          errorText: 'Name is required',
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
