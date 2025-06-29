import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/model/city/city.dart';
import 'package:travel_mobile/model/route/route.dart';
import 'package:travel_mobile/model/search_result.dart';
import 'package:travel_mobile/providers/account_provider.dart';
import 'package:travel_mobile/providers/city_provider.dart';
import 'package:travel_mobile/providers/route_provider.dart';

class RoutesSearchScreen extends StatefulWidget {
  const RoutesSearchScreen({super.key});

  @override
  State<RoutesSearchScreen> createState() => _RoutesSearchScreenState();
}

class _RoutesSearchScreenState extends State<RoutesSearchScreen> {
  int? selectedFromCityId;
  int? selectedToCityId;
  bool oneWayOnly = false;
  List<RouteModel> routes = [];
  bool isLoading = false;
  late RouteProvider _routeProvider;
  SearchResult<RouteModel>? result;
  late CityProvider _cityProvider;
  SearchResult<CityModel>? citiesResult;
  String? selectedSort = 'departureTime';
  Set<int> bookmarkedRouteIds = {};
  @override
  void initState() {
    super.initState();
    _cityProvider = context.read<CityProvider>();
    _routeProvider = context.read<RouteProvider>();

    _loadData();
    loadSavedRoutes();
  }

  _loadData() async {
    citiesResult = await _cityProvider.get();
    var data = await _routeProvider.get();
    setState(() {
      result = data;
    });
  }

  Future<void> loadSavedRoutes() async {
    var currentUser = context.read<AccountProvider>().getCurrentUser();
    final userId = currentUser.nameid;

    var savedRoutes = await _routeProvider.getSavedRoutes(userId!);

    setState(() {
      bookmarkedRouteIds = savedRoutes.map((r) => r.id!).toSet();
    });
  }

  Future<void> loadRoutes() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    var filter = {
      'fromCityId': selectedFromCityId,
      'toCityId': selectedToCityId
    };

    if (selectedFromCityId == null) {
      filter['fromCityId'] = null;
    }

    if (selectedToCityId == null) {
      filter['fromCityId'] = null;
    }

    var data = await _routeProvider.get(filter: filter);
    routes = data.result;
    setState(() => isLoading = false);
  }

  void sortRoutes() {
    routes.sort((a, b) {
      if (selectedSort == 'departureTime') {
        final aTime = a.departureTime ?? '';
        final bTime = b.departureTime ?? '';
        return aTime.compareTo(bTime);
      } else {
        final aPrice = a.adultPrice ?? 0;
        final bPrice = b.adultPrice ?? 0;
        return aPrice.compareTo(bPrice);
      }
    });
  }

  void toggleBookmark(int routeId) async {
    var currentUser = context.read<AccountProvider>().getCurrentUser();
    final userId = currentUser.nameid;
    final filter = {'passengerId': userId, 'routeId': routeId.toString()};

    bool success;
    if (bookmarkedRouteIds.contains(routeId)) {
      success = await _routeProvider.removeSavedRoute(filter: filter);
      if (success) {
        setState(() {
          bookmarkedRouteIds.remove(routeId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('🔁 Route #$routeId removed from bookmarks')),
        );
      }
    } else {
      success = await _routeProvider.saveRoute(filter: filter);
      if (success) {
        setState(() {
          bookmarkedRouteIds.add(routeId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Route #$routeId saved to bookmarks')),
        );
      }
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to update bookmark')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Active Routes")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedFromCityId,
                    decoration: const InputDecoration(labelText: "From"),
                    items: citiesResult?.result.map((city) {
                      return DropdownMenuItem(
                        value: city.id,
                        child: Text(city.name ?? ""),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => selectedFromCityId = value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedToCityId,
                    decoration: const InputDecoration(labelText: "To"),
                    items: citiesResult?.result.map((city) {
                      return DropdownMenuItem(
                        value: city.id,
                        child: Text(city.name ?? ""),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => selectedToCityId = value),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: oneWayOnly,
                  onChanged: (value) => setState(() => oneWayOnly = value!),
                ),
                const Text("One-way only"),
              ],
            ),
            Row(
              children: [
                const Text("Sort by:"),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedSort,
                  items: const [
                    DropdownMenuItem(
                        value: 'departureTime', child: Text("Departure Time")),
                    DropdownMenuItem(value: 'price', child: Text("Price")),
                  ],
                  onChanged: (value) => setState(() {
                    selectedSort = value;
                    sortRoutes();
                  }),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: loadRoutes,
                  child: const Text("Search"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : routes.isEmpty
                      ? const Center(child: Text("No routes found."))
                      : ListView.builder(
                          itemCount: routes.length,
                          itemBuilder: (context, index) {
                            final route = routes[index];
                            final isBookmarked =
                                bookmarkedRouteIds.contains(route.id);
                            final adultPrice = oneWayOnly
                                ? route.adultPrice! * 0.7
                                : route.adultPrice!;
                            final childPrice = oneWayOnly
                                ? route.childPrice! * 0.7
                                : route.childPrice!;

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Gornja linija: FROM → TO
                                    Text(
                                      "${route.fromCity!.name} → ${route.toCity!.name}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    // Vrijeme dolaska
                                    Text(
                                      "Arrival: ${route.arrivalTime}",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),

                                    const SizedBox(height: 8),

                                    if (!oneWayOnly) ...[
                                      // Donja linija: TO → FROM
                                      Text(
                                        "${route.toCity!.name} → ${route.fromCity!.name}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Departure: ${route.departureTime}",
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 8),
                                    ],

                                    // Cijene
                                    Text(
                                      "💰 Adult: ${adultPrice.toStringAsFixed(2)} BAM",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "🧒 Child: ${childPrice.toStringAsFixed(2)} BAM",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 8),

                                    // Agencija i Bookmark dugme
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              Text("🚍 ${route.agency!.name}"),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            isBookmarked
                                                ? Icons.bookmark
                                                : Icons.bookmark_border,
                                            color: isBookmarked
                                                ? Colors.amber
                                                : null,
                                          ),
                                          onPressed: () =>
                                              toggleBookmark(route.id!),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
            ),
          ],
        ),
      ),
    );
  }
}
