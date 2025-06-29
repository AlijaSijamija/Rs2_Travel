import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/model/route/route.dart';
import 'package:travel_mobile/providers/account_provider.dart';
import 'package:travel_mobile/providers/route_provider.dart';

class SavedRoutesScreen extends StatefulWidget {
  const SavedRoutesScreen({super.key});

  @override
  State<SavedRoutesScreen> createState() => _SavedRoutesScreenState();
}

class _SavedRoutesScreenState extends State<SavedRoutesScreen> {
  late RouteProvider _routeProvider;
  List<RouteModel> savedRoutes = [];
  bool isLoading = true;
  late String userId;

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
  }

  Future<void> removeBookmark(int routeId) async {
    final success = await _routeProvider.removeSavedRoute(
      filter: {'passengerId': userId, 'routeId': routeId.toString()},
    );

    if (success) {
      setState(() {
        savedRoutes.removeWhere((route) => route.id == routeId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Route #$routeId removed from bookmarks")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Failed to remove bookmark")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Routes")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : savedRoutes.isEmpty
              ? const Center(child: Text("You have no saved routes."))
              : ListView.builder(
                  itemCount: savedRoutes.length,
                  itemBuilder: (context, index) {
                    final route = savedRoutes[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gornja linija: FROM → TO
                            Text(
                              "${route.fromCity!.name} → ${route.toCity!.name}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Arrival: ${route.arrivalTime}",
                              style: const TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(height: 8),

                            // Donja linija: TO → FROM
                            Text(
                              "${route.toCity!.name} → ${route.fromCity!.name}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Departure: ${route.departureTime}",
                              style: const TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(height: 8),

                            // Cijene
                            Text(
                              "💰 Adult: ${route.adultPrice?.toStringAsFixed(2)} BAM",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "🧒 Child: ${route.childPrice?.toStringAsFixed(2)} BAM",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),

                            const SizedBox(height: 8),

                            // Agencija i dugme za uklanjanje
                            Row(
                              children: [
                                Expanded(
                                  child: Text("🚍 ${route.agency!.name}"),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.bookmark_remove,
                                      color: Colors.red),
                                  tooltip: "Remove from bookmarks",
                                  onPressed: () => removeBookmark(route.id!),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
    );
  }
}
