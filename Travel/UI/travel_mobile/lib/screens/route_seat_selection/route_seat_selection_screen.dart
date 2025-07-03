import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/model/route/route.dart';
import 'package:travel_mobile/providers/route_ticket.dart';
import 'package:travel_mobile/providers/trip_ticket_provider.dart';
import 'package:travel_mobile/screens/payment_route_ticket/payment_route_ticket_screen.dart';

class RouteSeatSelectionView extends StatefulWidget {
  final RouteModel? route;
  final bool oneWayOnly;
  final bool showDateInfo;
  final String validFrom;
  final String? validTo;
  const RouteSeatSelectionView(
      {super.key,
      required this.route,
      required this.oneWayOnly,
      this.showDateInfo = true,
      this.validFrom = "",
      this.validTo = ""});

  @override
  State<RouteSeatSelectionView> createState() => _RouteSeatSelectionViewState();
}

class _RouteSeatSelectionViewState extends State<RouteSeatSelectionView> {
  int adultCount = 1;
  int childCount = 0;

  Map<String, String> selectedSeats = {};
  List<String> reservedSeats = [];

  int get totalPassengers => adultCount + childCount;

  double get totalPrice {
    final baseAdultPrice = widget.route?.adultPrice ?? 0;
    final baseChildPrice = widget.route?.childPrice ?? 0;

    final adultPrice =
        widget.oneWayOnly ? baseAdultPrice * 0.7 : baseAdultPrice;
    final childPrice =
        widget.oneWayOnly ? baseChildPrice * 0.7 : baseChildPrice;

    return adultCount * adultPrice + childCount * childPrice;
  }

  @override
  void initState() {
    super.initState();
    fetchReservedSeats();
  }

  Future<void> fetchReservedSeats() async {
    final provider = Provider.of<RouteTicketProvider>(context, listen: false);
    final result = await provider.getReservedSeats(widget.route?.id ?? 0);

    setState(() {
      reservedSeats =
          result.map<String>((s) => s['seatNumber'] as String).toList();
    });
  }

  List<String> generateSeatLabels() {
    List<String> labels = [];
    int seatCount = widget.route?.numberOfSeats ?? 0;
    for (int i = 0; i < seatCount; i++) {
      int seatNumber = i + 1;
      String rowLetter = String.fromCharCode(65 + (i ~/ 4));
      labels.add('$seatNumber$rowLetter');
    }
    return labels;
  }

  Future<void> toggleSeat(String seat) async {
    if (selectedSeats.containsKey(seat)) {
      setState(() {
        selectedSeats.remove(seat);
      });
    } else {
      if (selectedSeats.length < totalPassengers) {
        final name = await showNameDialog(seat);
        if (name != null && name.trim().isNotEmpty) {
          setState(() {
            selectedSeats[seat] = name.trim();
          });
        }
      }
    }
  }

  Future<String?> showNameDialog(String seat) {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Insert passenger name $seat'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'First and last name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void showLimitWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cannot add more passengers than available seats.'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool allNamesEntered() {
    return selectedSeats.values.every((name) => name.trim().isNotEmpty);
  }

  void _showAddPassengerMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification'),
        content: const Text('Add passenger to select seat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final seats = generateSeatLabels();
    final availableSeats = widget.route?.availableSeats ?? 0;
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text("Selection of passengers and seats")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            if (widget.route != null) ...[
              Text(
                'Route: ${widget.route!.fromCity?.name ?? "-"} → ${widget.route!.toCity?.name ?? "-"}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (widget.showDateInfo) ...[
                const SizedBox(height: 4),
                Text(
                  'Departure time: ${widget.validFrom != null ? widget.validFrom : "-"}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Return Date: ${widget.validTo != null ? widget.validTo : "One way"}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
              const SizedBox(height: 16),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("Adults: "),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: adultCount > 0
                              ? () => setState(() => adultCount--)
                              : null,
                        ),
                        Text('$adultCount'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: totalPassengers < availableSeats
                              ? () => setState(() => adultCount++)
                              : showLimitWarning,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Children: "),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: childCount > 0
                              ? () => setState(() => childCount--)
                              : null,
                        ),
                        Text('$childCount'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: totalPassengers < availableSeats
                              ? () => setState(() => childCount++)
                              : showLimitWarning,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Total: ${totalPrice.toStringAsFixed(2)} BAM"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Select seat"),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                children: seats.map((seat) {
                  final isSelected = selectedSeats.containsKey(seat);
                  final isReserved = reservedSeats.contains(seat);
                  final passengerName = selectedSeats[seat] ?? '';

                  Widget seatIcon;
                  if (isReserved) {
                    seatIcon = Icon(Icons.event_seat,
                        color: Colors.red[700], size: 20);
                  } else if (isSelected) {
                    seatIcon = Icon(Icons.event_seat,
                        color: Colors.green[700], size: 20);
                  } else {
                    seatIcon = Icon(Icons.event_seat_outlined,
                        color: Colors.grey[600], size: 20);
                  }

                  return GestureDetector(
                    onTap: () async {
                      if (isReserved) return;
                      if (!isSelected &&
                          selectedSeats.length >= totalPassengers) {
                        _showAddPassengerMessage();
                        return;
                      }
                      await toggleSeat(seat);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isReserved
                            ? Colors.red[100]
                            : isSelected
                                ? Colors.green[100]
                                : Colors.grey[100],
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          seatIcon,
                          const SizedBox(height: 4),
                          Text(
                            seat,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          if (isReserved)
                            Flexible(
                              child: Text(
                                "Reserved",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.red),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            )
                          else if (passengerName.isNotEmpty)
                            Flexible(
                              child: Text(
                                passengerName,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black87),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  selectedSeats.length == totalPassengers && allNamesEntered()
                      ? () {
                          final seatPassengerList = selectedSeats.entries
                              .map((e) => {
                                    'seatNumber': e.key,
                                    'passengerName': e.value,
                                  })
                              .toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentRouteScreen(
                                route: widget.route,
                                seatPassengerData: seatPassengerList,
                                numberOfAdultPassengers: adultCount,
                                numberOfChildPassengers: childCount,
                                totalPrice: totalPrice,
                              ),
                            ),
                          );
                        }
                      : null,
              child: const Text("Continue to pay"),
            ),
          ],
        ),
      ),
    );
  }
}
