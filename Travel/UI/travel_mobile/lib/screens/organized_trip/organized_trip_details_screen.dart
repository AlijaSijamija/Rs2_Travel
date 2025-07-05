import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/providers/account_provider.dart';
import 'package:travel_mobile/providers/organized_trip_provider.dart';
import 'package:travel_mobile/screens/payment/payment_screen.dart';
import 'package:travel_mobile/screens/seat_selection/seat_selection_screen.dart';
import '../../model/organized_trip/organized_trip.dart';

class OrganizedTripDetailScreen extends StatefulWidget {
  final OrganizedTripModel? trip;

  const OrganizedTripDetailScreen({super.key, this.trip});

  @override
  State<OrganizedTripDetailScreen> createState() =>
      _OrganizedTripDetailScreenState();
}

class _OrganizedTripDetailScreenState extends State<OrganizedTripDetailScreen> {
  List<OrganizedTripModel>? recommendedTrips;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    if (widget.trip == null) {
      setState(() {
        isLoading = false;
        recommendedTrips = [];
      });
      return;
    }

    try {
      var currentUser = await context.read<AccountProvider>().getCurrentUser();
      var request = {
        "passengerId": currentUser.nameid,
        "tripId": widget.trip!.id.toString()
      };
      final trips =
          await context.read<OrganizedTripProvider>().recommended(request);

      setState(() {
        recommendedTrips = trips.result;
        isLoading = false;
      });
    } catch (e) {
      // Ako je greška, prikaži prazno ili poruku
      setState(() {
        recommendedTrips = [];
        isLoading = false;
      });
    }
  }

  String getFormattedDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd.MM.yyyy').format(date);
  }

  final emojiIcons = {
    'Accommodation': '🛏️',
    'Transportation': '🚗',
    'Breakfast': '🥐',
    'Tour Guide': '🧭',
    'Travel Insurance': '🛡️',
  };

  @override
  Widget build(BuildContext context) {
    final int randomImageIndex = Random().nextInt(6) + 1;
    final imageAsset = 'assets/images/trip$randomImageIndex.jpg';

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(32)),
                    child: Image.asset(
                      imageAsset,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Back button
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Content
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black26,
                      offset: Offset(0, -4),
                    )
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      widget.trip!.tripName,
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.trip!.destination,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          "${getFormattedDate(widget.trip!.startDate)} - ${getFormattedDate(widget.trip!.endDate)}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.price_change, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          "${widget.trip!.price?.toStringAsFixed(2) ?? '--'} BAM",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(Icons.event_seat),
                        const SizedBox(width: 4),
                        Text("${widget.trip!.availableSeats} seats left"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Description",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.trip!.description),
                    const SizedBox(height: 16),
                    const Text(
                      "Included Services",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.trip!.includedServices.map((s) {
                        return Chip(
                          avatar: Text(
                            emojiIcons[s.name] ?? '✔️',
                            style: const TextStyle(fontSize: 18),
                          ),
                          label: Text(s.name ?? ""),
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Contact Info",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(widget.trip!.contactInfo),
                    const SizedBox(height: 30),
                    widget.trip!.availableSeats == 0
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(top: 12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.warning_amber_rounded,
                                    color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  "This trip is sold out",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PassengerSeatSelectionView(
                                    organizedTrip: widget.trip,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.shopping_cart_checkout),
                            label: const Text("Book Now"),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),

                    // --- OVDJE DODAJEMO PREPORUKE ---
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (recommendedTrips != null &&
                        recommendedTrips!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Recommended for you based on your previous trips",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...recommendedTrips!.map((recTrip) {
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListTile(
                                  title: Text(recTrip.tripName),
                                  subtitle: Text(recTrip.destination),
                                  trailing: Text(
                                    "${getFormattedDate(recTrip.startDate)} - ${getFormattedDate(recTrip.endDate)}",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  onTap: () {
                                    // Navigacija na detalje preporučenog putovanja
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            OrganizedTripDetailScreen(
                                          trip: recTrip,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
