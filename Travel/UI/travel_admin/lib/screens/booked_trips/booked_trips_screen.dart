import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_admin/providers/trip_ticket_provider.dart';
import 'package:travel_admin/widgets/master_screen.dart';

class BookedTripsScreen extends StatefulWidget {
  final String userId;
  const BookedTripsScreen({super.key, required this.userId});

  @override
  State<BookedTripsScreen> createState() => _BookedTripsScreenState();
}

class _BookedTripsScreenState extends State<BookedTripsScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> allBookedTrips = [];
  List<dynamic> filteredTrips = [];
  bool? passed; // false = upcoming, true = passed
  bool isLoading = false;
  late TabController _tabController;
  String tripNameFilter = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadCurrentUserAndTrips();
  }

  Future<void> _loadCurrentUserAndTrips() async {
    _handleTabChange(); // initial load
  }

  Future<void> loadTrips() async {
    setState(() {
      isLoading = true;
    });

    var filter = {
      'passengerId': widget.userId ?? '',
      'passed': passed.toString(),
    };

    var provider = context.read<TripTicketProvider>();
    var trips = await provider.getBookedTrips(filter: filter);

    setState(() {
      allBookedTrips = trips;
      isLoading = false;
    });

    _applyTripNameFilter();
  }

  void _applyTripNameFilter() {
    final query = tripNameFilter.toLowerCase();
    final filtered = tripNameFilter.isEmpty
        ? allBookedTrips
        : allBookedTrips
            .where((trip) => (trip['destination'] ?? '')
                .toString()
                .toLowerCase()
                .contains(query))
            .toList();

    setState(() {
      filteredTrips = filtered;
    });
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      passed = _tabController.index == 1;
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
    return MasterScreenWidget(
      title: "User Booked Trips",
      showBackButton: true, // set true if needed
      child: Column(
        children: [
          // Add TabBar here
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
                        child: TextField(
                          decoration: const InputDecoration(
                              labelText: "Search by destination"),
                          onChanged: (value) {
                            setState(() => tripNameFilter = value);
                            _applyTripNameFilter();
                          },
                        ),
                      ),
                      Expanded(
                        child: filteredTrips.isEmpty
                            ? const Center(child: Text("No trips found."))
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: filteredTrips.length,
                                itemBuilder: (context, tripIndex) {
                                  final trip = filteredTrips[tripIndex];
                                  final tickets =
                                      (trip['tripTickets'] as List<dynamic>)
                                          .where((o) =>
                                              o['passengerId'] == widget.userId)
                                          .toList();

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "🚌 Trip to ${trip['destination'] ?? 'Unknown'}",
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
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                          ? "PAST TRIP"
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
