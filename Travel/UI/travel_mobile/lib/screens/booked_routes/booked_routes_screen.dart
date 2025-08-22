import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/model/city/city.dart';
import 'package:travel_mobile/providers/account_provider.dart';
import 'package:travel_mobile/providers/city_provider.dart';
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
  List<CityModel> cities = [];
  late CityProvider _cityProvider;
  int? selectedFromCityId;
  int? selectedToCityId;
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _cityProvider = context.read<CityProvider>();
    _loadCities();
    _loadCurrentUserAndRoutes();
  }

  Future<void> _loadCities() async {
    final response = await _cityProvider.get();
    setState(() {
      cities = response.result;
    });
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
    final filtered = allBookedRoutes.where((route) {
      final fromCityId = route['fromCity']?['id'] as int?;
      final toCityId = route['toCity']?['id'] as int?;

      final matchesFrom =
          selectedFromCityId == null || fromCityId == selectedFromCityId;
      final matchesTo =
          selectedToCityId == null || toCityId == selectedToCityId;

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
      selectedFromCityId = null;
      selectedToCityId = null;
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
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Upcoming"),
              Tab(text: "Passed"),
            ],
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            DropdownButtonFormField<int?>(
                              value: selectedFromCityId,
                              decoration:
                                  const InputDecoration(labelText: "From City"),
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text("All"),
                                ),
                                ...cities.map((city) => DropdownMenuItem(
                                      value: city.id,
                                      child: Text(city.name ?? ""),
                                    )),
                              ],
                              onChanged: (value) {
                                setState(() => selectedFromCityId = value);
                                _applyRouteFilter();
                              },
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<int?>(
                              value: selectedToCityId,
                              decoration:
                                  const InputDecoration(labelText: "To City"),
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text("All"),
                                ),
                                ...cities.map((city) => DropdownMenuItem(
                                      value: city.id,
                                      child: Text(city.name ?? ""),
                                    )),
                              ],
                              onChanged: (value) {
                                setState(() => selectedToCityId = value);
                                _applyRouteFilter();
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: filteredRoutes.isEmpty
                            ? const Center(
                                child: Text("No route tickets found."))
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: filteredRoutes.length,
                                itemBuilder: (context, routeIndex) {
                                  final route = filteredRoutes[routeIndex];

                                  // Filtriranje karata za trenutnog korisnika
                                  final tickets =
                                      (route['routeTickets'] as List<dynamic>)
                                          .where((o) =>
                                              o['passengerId'] == currentUserId)
                                          .toList();
                                  final now = DateTime.now();
                                  final filteredTickets =
                                      tickets.where((ticket) {
                                    final arrivalDateStr =
                                        ticket['arrivalDate'] as String?;
                                    final departureDateStr =
                                        ticket['departureDate'] as String?;

                                    final arrivalDate = arrivalDateStr != null
                                        ? DateTime.tryParse(arrivalDateStr)
                                        : null;
                                    final returnDate = departureDateStr != null
                                        ? DateTime.tryParse(departureDateStr)
                                        : null;

                                    if (arrivalDate == null) {
                                      return false; // karta je nevažeća bez datuma odlaska (arrival)
                                    }

                                    bool isUpcoming;

                                    if (returnDate == null) {
                                      // One-way karta → koristi samo arrivalDate
                                      isUpcoming = arrivalDate.isAfter(now) ||
                                          arrivalDate.isAtSameMomentAs(now);
                                    } else {
                                      // Povratna → koristi oba datuma
                                      isUpcoming = arrivalDate.isAfter(now) ||
                                          arrivalDate.isAtSameMomentAs(now) ||
                                          returnDate.isAfter(now) ||
                                          returnDate.isAtSameMomentAs(now);
                                    }

                                    return passed == true
                                        ? !isUpcoming
                                        : isUpcoming;
                                  }).toList();

                                  if (filteredTickets.isEmpty) {
                                    return Container(); // Ne prikazuj ako nema karata u tabu
                                  }

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "🚌 Route: ${route['fromCity']['name']}-${route['toCity']['name']}",
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ...filteredTickets
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        int ticketIndex = entry.key;
                                        var ticket = entry.value;

                                        final departureDateStr =
                                            ticket['departureDate'] as String?;
                                        final arrivalDateStr =
                                            ticket['arrivalDate'] as String?;

                                        final departureDate =
                                            departureDateStr != null
                                                ? DateTime.tryParse(
                                                    departureDateStr)
                                                : null;
                                        final arrivalDate = arrivalDateStr !=
                                                null
                                            ? DateTime.tryParse(arrivalDateStr)
                                            : null;

                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade400),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.grey.shade100,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
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
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "🎫 Ticket #${ticketIndex + 1}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
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
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          "📅 Arrival date: ${arrivalDate != null ? dateFormatter.format(arrivalDate) : '-'}",
                                                        ),
                                                        if (ticket[
                                                                'departureDate'] !=
                                                            null)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 4.0),
                                                            child: Text(
                                                              "📅 Return: ${dateFormatter.format(DateTime.parse(ticket['departureDate']))}",
                                                            ),
                                                          ),
                                                      ]),
                                                ),
                                              ),
                                              Container(
                                                width: 80,
                                                height: 140,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black87,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(12),
                                                    bottomRight:
                                                        Radius.circular(12),
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
                                                        fontWeight:
                                                            FontWeight.bold,
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
          ),
        ],
      ),
    );
  }
}
