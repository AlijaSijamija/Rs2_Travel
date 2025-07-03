import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/providers/account_provider.dart';
import 'package:travel_mobile/providers/route_ticket.dart';
import 'package:travel_mobile/widgets/master_screen.dart';

class BookedRoutesScreen extends StatefulWidget {
  const BookedRoutesScreen({super.key});

  @override
  State<BookedRoutesScreen> createState() => _BookedRoutesScreenState();
}

class _BookedRoutesScreenState extends State<BookedRoutesScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> allBookedRoutes = [];
  List<dynamic> filteredRoutes = [];
  bool? passed;
  bool isLoading = false;
  late TabController _tabController;
  String? currentUserId;

  String cityFromFilter = '';
  String cityToFilter = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadCurrentUserAndRoutes();
  }

  Future<void> _loadCurrentUserAndRoutes() async {
    var currentUser = await context.read<AccountProvider>().getCurrentUser();
    currentUserId = currentUser.nameid;
    _handleTabChange();
  }

  Future<void> loadRoutes() async {
    setState(() {
      isLoading = true;
    });

    var provider = context.read<RouteTicketProvider>();
    var routes = await provider.getRouteTickets(currentUserId!);

    setState(() {
      allBookedRoutes = routes;
      isLoading = false;
    });

    _applyRouteFilter();
  }

  void _applyRouteFilter() {
    final fromQuery = cityFromFilter.toLowerCase();
    final toQuery = cityToFilter.toLowerCase();

    final filtered = allBookedRoutes.where((route) {
      final fromCity =
          (route['fromCity']?['name'] ?? '').toString().toLowerCase();
      final toCity = (route['toCity']?['name'] ?? '').toString().toLowerCase();

      final matchesFrom = fromQuery.isEmpty || fromCity.contains(fromQuery);
      final matchesTo = toQuery.isEmpty || toCity.contains(toQuery);

      return matchesFrom && matchesTo;
    }).toList();

    setState(() {
      filteredRoutes = filtered;
    });
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      passed = _tabController.index == 1;
    });
    loadRoutes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "My route tickets",
      showBackButton: false,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration:
                            const InputDecoration(labelText: "From City"),
                        onChanged: (value) {
                          setState(() => cityFromFilter = value);
                          _applyRouteFilter();
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        decoration: const InputDecoration(labelText: "To City"),
                        onChanged: (value) {
                          setState(() => cityToFilter = value);
                          _applyRouteFilter();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredRoutes.isEmpty
                      ? const Center(child: Text("No route tickets found."))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredRoutes.length,
                          itemBuilder: (context, routeIndex) {
                            final route = filteredRoutes[routeIndex];
                            final tickets = (route['routeTickets']
                                    as List<dynamic>)
                                .where((o) => o['passengerId'] == currentUserId)
                                .toList();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "🚌 Route: ${route['fromCity']['name']}-${route['toCity']['name']}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...tickets.asMap().entries.map((entry) {
                                  int ticketIndex = entry.key;
                                  var ticket = entry.value;
                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.shade100,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "🎫 Ticket #${ticketIndex + 1}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "👤 Passenger: ${ticket['passenger']?['firstName'] ?? ''} ${ticket['passenger']?['lastName'] ?? ''}",
                                                ),
                                                Text(
                                                  "🏢 Agency: ${route['agency']?['name'] ?? 'Unknown'}",
                                                ),
                                                Text(
                                                  "🧍 Adult Passengers: ${ticket['numberOfAdultPassengers'] ?? '-'}",
                                                ),
                                                Text(
                                                  "🧒 Child Passengers: ${ticket['numberOfChildPassengers'] ?? '-'}",
                                                ),
                                                Text(
                                                  "💰 Price: ${ticket['price'] != null ? (ticket['price'] as num).toStringAsFixed(2) : '0.00'} BAM",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 80,
                                          height: 140,
                                          decoration: const BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(12),
                                              bottomRight: Radius.circular(12),
                                            ),
                                          ),
                                          child: RotatedBox(
                                            quarterTurns: 1,
                                            child: Center(
                                              child: Text(
                                                passed == true
                                                    ? "PAST TICKETS"
                                                    : "UPCOMING",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.5,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                const SizedBox(height: 24),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
