import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/model/route/route.dart';
import 'package:travel_mobile/providers/account_provider.dart';
import 'package:travel_mobile/providers/route_provider.dart';
import 'package:travel_mobile/screens/route_seat_selection/route_seat_selection_screen.dart';
import 'package:travel_mobile/widgets/master_screen.dart';

class SavedRoutesScreen extends StatefulWidget {
  const SavedRoutesScreen({super.key});

  @override
  State<SavedRoutesScreen> createState() => _SavedRoutesScreenState();
}

class _SavedRoutesScreenState extends State<SavedRoutesScreen> {
  late RouteProvider _routeProvider;
  List<RouteModel> savedRoutes = [];
  List<RouteModel> filteredRoutes = [];
  bool isLoading = true;
  late String userId;

  String fromCityFilter = '';
  String toCityFilter = '';
  String sortOrder = 'asc'; // 'asc' or 'desc'

  @override
  void initState() {
    super.initState();
    _routeProvider = context.read<RouteProvider>();
    userId = context.read<AccountProvider>().getCurrentUser().nameid!;
    loadSavedRoutes();
  }

  Future<void> loadSavedRoutes() async {
    setState(() => isLoading = true);
    final routes = await _routeProvider.getSavedRoutes(userId);
    setState(() {
      savedRoutes = routes;
      isLoading = false;
    });
    applyFilters();
  }

  void applyFilters() {
    List<RouteModel> filtered = savedRoutes.where((route) {
      final fromMatch = route.fromCity!.name!
          .toLowerCase()
          .contains(fromCityFilter.toLowerCase());
      final toMatch = route.toCity!.name!
          .toLowerCase()
          .contains(toCityFilter.toLowerCase());
      return fromMatch && toMatch;
    }).toList();

    filtered.sort((a, b) {
      final aPrice = a.adultPrice ?? 0;
      final bPrice = b.adultPrice ?? 0;
      return sortOrder == 'asc'
          ? aPrice.compareTo(bPrice)
          : bPrice.compareTo(aPrice);
    });

    setState(() {
      filteredRoutes = filtered;
    });
  }

  Future<void> removeBookmark(int routeId) async {
    final success = await _routeProvider.removeSavedRoute(
      filter: {'passengerId': userId, 'routeId': routeId.toString()},
    );

    if (success) {
      setState(() {
        savedRoutes.removeWhere((route) => route.id == routeId);
      });
      applyFilters();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Route #$routeId removed from bookmarks")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Failed to remove bookmark")),
      );
    }
  }

  Future<void> _confirmRemoveBookmark(int routeId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove saved route"),
        content: const Text(
            "Are you sure you want to remove this route from your saved list?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Remove"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await removeBookmark(routeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Saved Routes",
      showBackButton: false, // set true if this screen needs a back button
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : savedRoutes.isEmpty
              ? const Center(child: Text("You have no saved routes."))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Filters
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration:
                                  const InputDecoration(labelText: "From City"),
                              onChanged: (value) {
                                setState(() => fromCityFilter = value);
                                applyFilters();
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration:
                                  const InputDecoration(labelText: "To City"),
                              onChanged: (value) {
                                setState(() => toCityFilter = value);
                                applyFilters();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text("Sort by Price:"),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: sortOrder,
                            items: const [
                              DropdownMenuItem(
                                  value: 'asc',
                                  child: Text("Lowest to Highest")),
                              DropdownMenuItem(
                                  value: 'desc',
                                  child: Text("Highest to Lowest")),
                            ],
                            onChanged: (value) {
                              setState(() => sortOrder = value!);
                              applyFilters();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Filtered route list
                      Expanded(
                        child: filteredRoutes.isEmpty
                            ? const Center(
                                child: Text("No routes match your filters."))
                            : ListView.builder(
                                itemCount: filteredRoutes.length,
                                itemBuilder: (context, index) {
                                  final route = filteredRoutes[index];

                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${route.fromCity!.name} → ${route.toCity!.name}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Arrival: ${route.arrivalTime}",
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "${route.toCity!.name} → ${route.fromCity!.name}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Departure: ${route.departureTime}",
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "💰 Adult: ${route.adultPrice?.toStringAsFixed(2)} BAM",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            "🧒 Child: ${route.childPrice?.toStringAsFixed(2)} BAM",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                      "🚍 ${route.agency!.name}")),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.bookmark_remove,
                                                    color: Colors.red),
                                                tooltip:
                                                    "Remove from bookmarks",
                                                onPressed: () =>
                                                    _confirmRemoveBookmark(
                                                        route.id!),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RouteSeatSelectionView(
                                                      route: route,
                                                      oneWayOnly: false,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text("Buy Ticket"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
