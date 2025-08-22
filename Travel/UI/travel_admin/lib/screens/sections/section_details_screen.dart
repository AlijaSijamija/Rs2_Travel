import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:travel_admin/model/section/section.dart';
import 'package:travel_admin/providers/section_provider.dart';
import 'package:travel_admin/screens/sections/section_list_screen.dart';
import 'package:travel_admin/widgets/master_screen.dart';

class SectionDetailScreen extends StatefulWidget {
  SectionModel? sectionModel;
  SectionDetailScreen({super.key, this.sectionModel});

  @override
  State<SectionDetailScreen> createState() => _SectionDetailScreenState();
}

class _SectionDetailScreenState extends State<SectionDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late SectionProvider _sectionProvider;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'name': widget.sectionModel?.name,
    };
    _sectionProvider = context.read<SectionProvider>();
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
                        if (widget.sectionModel == null) {
                          await _sectionProvider.insert(request);
                        } else {
                          await _sectionProvider.update(
                              widget.sectionModel!.id!, request);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.sectionModel == null
                                  ? 'Section successfully created'
                                  : 'Section successfully updated',
                            ),
                          ),
                        );
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SectionListScreen()));
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
              if (widget.sectionModel != null) ...[
                ElevatedButton(
                  onPressed: () {
                    // Show delete confirmation dialog here
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Delete"),
                          content: Text(
                              "Are you sure you want to delete this section?"),
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
                                  if (widget.sectionModel != null) {
                                    await _sectionProvider
                                        .delete(widget.sectionModel!.id!);
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    Navigator.of(context).pop();
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SectionListScreen(),
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
      title: this.widget.sectionModel?.name ?? "Section details",
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
