import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/model/organized_trip/organized_trip.dart';
import 'package:travel_mobile/providers/organized_trip_provider.dart';
import 'package:travel_mobile/screens/organized_trip/organized_trip_details_screen.dart';
import '../../providers/account_provider.dart';
import '../../widgets/master_screen.dart';

class OrganizedTripListScreen extends StatefulWidget {
  const OrganizedTripListScreen({Key? key});

  @override
  State<OrganizedTripListScreen> createState() =>
      _OrganizedTripListScreenState();
}

class _OrganizedTripListScreenState extends State<OrganizedTripListScreen> {
  late OrganizedTripProvider _organizedTripProvider;
  List<OrganizedTripModel>? organizedTrips;
  List<OrganizedTripModel>? filteredTrips;
  late AccountProvider _accountProvider;

  String _searchQuery = '';
  String _sortOrder = 'Price: Low to High';

  final Map<String, IconData> serviceIcons = {
    'Accommodation': Icons.hotel,
    'Transportation': Icons.directions_car,
    'Breakfast': Icons.free_breakfast,
    'Tour Guide': Icons.tour,
    'Travel Insurance': Icons.security,
  };

  @override
  void initState() {
    super.initState();
    _organizedTripProvider = context.read<OrganizedTripProvider>();
    _accountProvider = context.read<AccountProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var organizedTripsData = await _organizedTripProvider.get();
      setState(() {
        organizedTrips = organizedTripsData.result;
        filteredTrips = List.from(organizedTrips ?? []);
        _applyFilterAndSort();
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  void _applyFilterAndSort() {
    if (organizedTrips == null) return;

    // Filter by trip name
    filteredTrips = organizedTrips!
        .where((trip) =>
            trip.tripName != null &&
            trip.tripName!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    // Sort
    if (_sortOrder == 'Price: Low to High') {
      filteredTrips!.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    } else if (_sortOrder == 'Price: High to Low') {
      filteredTrips!.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Organized Trips"),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _buildSearchAndSort(),
              const SizedBox(height: 10),
              Expanded(child: _buildTripList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndSort() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(labelText: "Search by trip name"),
          onChanged: (value) {
            setState(() => _searchQuery = value);
            _applyFilterAndSort();
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 200, // optional: to keep dropdown width reasonable
          child: DropdownButtonFormField<String>(
            value: _sortOrder,
            decoration: const InputDecoration(
              labelText: 'Sort by',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(
                value: 'Price: Low to High',
                child: Text('Price: Low to High'),
              ),
              DropdownMenuItem(
                value: 'Price: High to Low',
                child: Text('Price: High to Low'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                _sortOrder = value;
                _applyFilterAndSort();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTripList() {
    if (filteredTrips == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredTrips!.isEmpty) {
      return const Center(
        child: Text(
          'No organized trips found.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      );
    }

    return ListView.separated(
      itemCount: filteredTrips!.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final trip = filteredTrips![index];
        return Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.tripName ?? "Unnamed Trip",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  trip.destination ?? "No destination",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 6),
                Text(
                  trip.description ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: trip.includedServices.map((service) {
                    final emojiIcons = {
                      'Accommodation': '🛏️',
                      'Transportation': '🚗',
                      'Breakfast': '🥐',
                      'Tour Guide': '🧭',
                      'Travel Insurance': '🛡️',
                    };

                    return Chip(
                      label: Text(
                        "${emojiIcons[service.name] ?? '✔️'} ${service.name}",
                        style: const TextStyle(color: Colors.black),
                      ),
                      backgroundColor: Colors.white,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price: ${trip.price?.toStringAsFixed(2) ?? '--'} BAM",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      (trip.availableSeats ?? 0) == 0
                          ? "Sold out"
                          : "${trip.availableSeats} seats left",
                      style: TextStyle(
                        color: (trip.availableSeats ?? 0) == 0
                            ? Colors.grey
                            : (trip.availableSeats! < 10
                                ? Colors.red
                                : Colors.green),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              OrganizedTripDetailScreen(trip: trip),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(220, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Details"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
