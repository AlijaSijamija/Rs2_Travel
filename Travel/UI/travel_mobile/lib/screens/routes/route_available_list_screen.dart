import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/model/route/route.dart';
import 'package:travel_mobile/providers/account_provider.dart';
import 'package:travel_mobile/providers/route_provider.dart';
import 'package:travel_mobile/screens/route_seat_selection/route_seat_selection_screen.dart';
import 'package:travel_mobile/widgets/master_screen.dart';

class RoutesListScreen extends StatefulWidget {
  final int fromCityId;
  final int toCityId;
  final String validFrom;
  final String? validTo;
  final bool oneWayOnly;

  const RoutesListScreen({
    super.key,
    required this.fromCityId,
    required this.toCityId,
    required this.validFrom,
    this.validTo,
    required this.oneWayOnly,
  });

  @override
  State<RoutesListScreen> createState() => _RoutesListScreenState();
}

class _RoutesListScreenState extends State<RoutesListScreen> {
  late Future<List<RouteModel>> _routesFuture;
  List<RouteModel> _routes = [];
  Set<int> _bookmarkedRouteIds = {};
  String _selectedSort = 'departureTime';
  late RouteProvider _routeProvider;
  late String userId;
  @override
  void initState() {
    super.initState();
    _routeProvider = context.read<RouteProvider>();
    userId = context.read<AccountProvider>().getCurrentUser().nameid!;
    _routesFuture = _fetchRoutes();
  }

  Future<List<RouteModel>> _fetchRoutes() async {
    var filter = {
      'fromCityId': widget.fromCityId,
      ' toCityId': widget.toCityId,
      'validFrom': widget.validFrom,
      'validTo': widget.validTo
    };
    final response = await context.read<RouteProvider>().get(filter: filter);
    setState(() {
      _routes = response.result;
    });
    return response.result;
  }

  void _toggleBookmark(int routeId) {
    setState(() {
      if (_bookmarkedRouteIds.contains(routeId)) {
        _routeProvider.removeSavedRoute(
          filter: {'passengerId': userId, 'routeId': routeId.toString()},
        );
        _bookmarkedRouteIds.remove(routeId);
      } else {
        _routeProvider.saveRoute(
          filter: {
            'passengerId': userId,
            'routeId': routeId.toString(),
            'validFrom': widget.validFrom,
            'validTo': widget.validTo
          },
        );
        _bookmarkedRouteIds.add(routeId);
      }
    });
  }

  void _onSortChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedSort = value;
      _routes.sort((a, b) {
        if (value == 'price') {
          return a.adultPrice!.compareTo(b.adultPrice!);
        } else {
          return a.departureTime!.compareTo(b.departureTime!);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Available Routes",
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<RouteModel>>(
          future: _routesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final routes = snapshot.data ?? [];

            if (routes.isEmpty) {
              return const Center(child: Text("No routes found."));
            }

            return Column(
              children: [
                Row(
                  children: [
                    const Text("Sort by:"),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: _selectedSort,
                      items: const [
                        DropdownMenuItem(
                          value: 'departureTime',
                          child: Text("Departure Time"),
                        ),
                        DropdownMenuItem(
                          value: 'price',
                          child: Text("Price"),
                        ),
                      ],
                      onChanged: _onSortChanged,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: routes.length,
                    itemBuilder: (context, index) {
                      final route = routes[index];
                      final isBookmarked =
                          _bookmarkedRouteIds.contains(route.id);
                      final adultPrice = widget.oneWayOnly
                          ? route.adultPrice! * 0.7
                          : route.adultPrice!;
                      final childPrice = widget.oneWayOnly
                          ? route.childPrice! * 0.7
                          : route.childPrice!;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${route.fromCity!.name} → ${route.toCity!.name}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text("Arrival: ${route.arrivalTime}",
                                  style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              if (!widget.oneWayOnly) ...[
                                Text(
                                  "${route.toCity!.name} → ${route.fromCity!.name}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("Departure: ${route.departureTime}",
                                    style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 8),
                              ],
                              Text(
                                  "💰 Adult: ${adultPrice.toStringAsFixed(2)} BAM",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  "🧒 Child: ${childPrice.toStringAsFixed(2)} BAM",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("🚍 ${route.agency!.name}")),
                                  IconButton(
                                    icon: Icon(
                                      isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: isBookmarked ? Colors.amber : null,
                                    ),
                                    onPressed: () => _toggleBookmark(route.id!),
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
                                          oneWayOnly: widget.oneWayOnly,
                                          validFrom: widget.validFrom,
                                          validTo: widget.validTo,
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
            );
          },
        ),
      ),
    );
  }
}
