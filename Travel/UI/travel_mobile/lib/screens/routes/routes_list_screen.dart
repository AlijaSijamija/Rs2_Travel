import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/model/city/city.dart';
import 'package:travel_mobile/providers/city_provider.dart';
import 'package:travel_mobile/screens/routes/route_available_list_screen.dart';
import 'package:travel_mobile/widgets/master_screen.dart';

class RoutesSearchScreen extends StatefulWidget {
  const RoutesSearchScreen({super.key});

  @override
  State<RoutesSearchScreen> createState() => _RoutesSearchScreenState();
}

class _RoutesSearchScreenState extends State<RoutesSearchScreen> {
  int? selectedFromCityId;
  int? selectedToCityId;
  bool oneWayOnly = false;
  DateTime? validFrom = DateTime.now();
  DateTime? validTo = DateTime.now();

  late CityProvider _cityProvider;
  List<CityModel> cities = [];

  @override
  void initState() {
    super.initState();
    _cityProvider = context.read<CityProvider>();
    _loadCities();
  }

  Future<void> _loadCities() async {
    final response = await _cityProvider.get();
    setState(() {
      cities = response.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Search Routes",
      showBackButton: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: selectedFromCityId,
              decoration: const InputDecoration(labelText: "From City"),
              items: cities
                  .map((city) => DropdownMenuItem(
                        value: city.id,
                        child: Text(city.name ?? ""),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedFromCityId = value),
            ),
            const SizedBox(height: 16),
            const Text("Departure Date"),
            CalendarDatePicker(
              initialDate: validFrom!,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              onDateChanged: (date) {
                setState(() {
                  validFrom = date;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: selectedToCityId,
              decoration: const InputDecoration(labelText: "To City"),
              items: cities
                  .map((city) => DropdownMenuItem(
                        value: city.id,
                        child: Text(city.name ?? ""),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedToCityId = value),
            ),
            const SizedBox(height: 16),
            if (!oneWayOnly) ...[
              const Text("Return Date (optional)"),
              CalendarDatePicker(
                initialDate: validTo,
                firstDate: validFrom!,
                lastDate: DateTime(2100),
                onDateChanged: (date) => setState(() => validTo = date),
              ),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Checkbox(
                  value: oneWayOnly,
                  onChanged: (value) => setState(() => oneWayOnly = value!),
                ),
                const Text("One-way only"),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedFromCityId == null || selectedToCityId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select both cities")),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoutesListScreen(
                        fromCityId: selectedFromCityId!,
                        toCityId: selectedToCityId!,
                        validFrom: DateFormat('yyyy-MM-dd').format(validFrom!),
                        validTo: oneWayOnly || validTo == null
                            ? null
                            : DateFormat('yyyy-MM-dd').format(validTo!),
                        oneWayOnly: oneWayOnly,
                      ),
                    ),
                  );
                },
                child: const Text("Search"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
