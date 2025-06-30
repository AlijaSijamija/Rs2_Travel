import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/model/organized_trip/organized_trip.dart';
import 'package:travel_mobile/providers/trip_ticket_provider.dart';
import 'package:travel_mobile/screens/payment/payment_screen.dart';

class PassengerSeatSelectionView extends StatefulWidget {
  final OrganizedTripModel? organizedTrip;

  const PassengerSeatSelectionView({super.key, required this.organizedTrip});

  @override
  State<PassengerSeatSelectionView> createState() =>
      _PassengerSeatSelectionViewState();
}

class _PassengerSeatSelectionViewState
    extends State<PassengerSeatSelectionView> {
  int passengerCount = 1;
  double seatPrice = 0;
  Map<String, String> selectedSeats = {};
  List<String> reservedSeats = [];

  int get discount => passengerCount >= 5 ? 20 : 0;

  double get totalPrice => passengerCount * seatPrice * (1 - discount / 100);

  @override
  void initState() {
    super.initState();
    fetchReservedSeats();
    seatPrice = widget.organizedTrip?.price ?? 0;
  }

  Future<void> fetchReservedSeats() async {
    final provider = Provider.of<TripTicketProvider>(context, listen: false);
    final result =
        await provider.getReservedSeats(widget.organizedTrip?.id ?? 0);

    setState(() {
      reservedSeats =
          result.map<String>((s) => s['seatNumber'] as String).toList();
    });
  }

  List<String> generateSeatLabels() {
    List<String> labels = [];

    int seatCount = widget.organizedTrip?.numberOfSeats ?? 0;

    for (int i = 0; i < seatCount; i++) {
      int seatNumber = i + 1; // from 1 to seatCount
      // Assign a row letter every 4 seats
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
      if (selectedSeats.length < passengerCount) {
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
          decoration: const InputDecoration(
            labelText: 'First and last name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, controller.text);
            },
            child: const Text('Confirm'),
          ),
        ],
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

    return Scaffold(
      appBar: AppBar(title: const Text("Selection of passengers and seats")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Passenger count: "),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: passengerCount > 1
                      ? () {
                          setState(() {
                            passengerCount--;
                            if (selectedSeats.length > passengerCount) {
                              selectedSeats.removeWhere((key, _) =>
                                  selectedSeats.keys.toList().indexOf(key) >=
                                  passengerCount);
                            }
                          });
                        }
                      : null,
                ),
                Text('$passengerCount'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final availableSeats =
                        widget.organizedTrip?.availableSeats ?? 0;
                    if (passengerCount < availableSeats) {
                      setState(() => passengerCount++);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'You cannot add more passengers than available seats.'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Discount: $discount%"),
                    Text("Price: ${totalPrice.toStringAsFixed(2)} BAM"),
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

                  // Icon based on seat status
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
                      if (isReserved) return; // no action on reserved seats

                      if (!isSelected &&
                          selectedSeats.length >= passengerCount) {
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
                  selectedSeats.length == passengerCount && allNamesEntered()
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
                              builder: (context) => PaymentScreen(
                                organizedTrip: widget.organizedTrip,
                                seatPassengerData: seatPassengerList,
                                numberOfPassengers: passengerCount,
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
