import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/providers/account_provider.dart';
import 'package:travel_mobile/providers/trip_ticket_provider.dart';

class BookedTripsScreen extends StatefulWidget {
  const BookedTripsScreen({super.key});

  @override
  State<BookedTripsScreen> createState() => _BookedTripsScreenState();
}

class _BookedTripsScreenState extends State<BookedTripsScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> bookedTrips = [];
  bool? passed; // null will not be used now, only true or false
  bool isLoading = false;
  late TabController _tabController;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadCurrentUserAndTrips();
  }

  Future<void> _loadCurrentUserAndTrips() async {
    var currentUser = await context.read<AccountProvider>().getCurrentUser();
    currentUserId = currentUser.nameid;
    _handleTabChange(); // initial load trips
  }

  Future<void> loadTrips() async {
    setState(() {
      isLoading = true;
    });

    var filter = {
      'passengerId': currentUserId ?? '',
      'passed': passed.toString(),
    };

    var _tripTicketProvider = context.read<TripTicketProvider>();
    var trips = await _tripTicketProvider.getBookedTrips(filter: filter);
    setState(() {
      bookedTrips = trips;
      isLoading = false;
    });
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      passed = _tabController.index == 1; // false for Upcoming, true for Passed
    });
    loadTrips();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Booked Trips"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Upcoming"),
            Tab(text: "Passed"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookedTrips.isEmpty
              ? const Center(child: Text("No trips found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookedTrips.length,
                  itemBuilder: (context, tripIndex) {
                    final trip = bookedTrips[tripIndex];
                    // Filter tickets for current user on this trip
                    final tickets = (trip['tripTickets'] as List<dynamic>)
                        .where((o) => o['passengerId'] == currentUserId)
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🚌 Trip to ${trip['destination'] ?? 'Unknown'}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // For each ticket, show a card with details
                        ...tickets.asMap().entries.map((entry) {
                          int ticketIndex = entry.key;
                          var ticket = entry.value;
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
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
                                            "👤 Passenger: ${ticket['passenger']?['firstName'] ?? ''} ${ticket['passenger']?['lastName'] ?? ''}"),
                                        Text(
                                            "🏢 Agency: ${ticket['agency']?['name'] ?? 'Unknown'}"),
                                        Text(
                                            "🧍 Passengers: ${ticket['numberOfPassengers'] ?? '-'}"),
                                        Text(
                                            "💰 Price: ${ticket['price'] != null ? (ticket['price'] as num).toStringAsFixed(2) : '0.00'} KM"),
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
                                            ? "PAST TRIP"
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
    );
  }
}
