import 'package:flutter/material.dart';
import 'package:travel_mobile/model/route/route.dart';
import 'package:travel_mobile/screens/home/home_screen.dart';
import 'package:travel_mobile/widgets/master_screen.dart';

class PaymentRouteSuccessScreen extends StatelessWidget {
  final RouteModel route;
  final double totalPrice;
  final int numberOfAdultPassengers;
  final int numberOfChildPassengers;
  final String arrivalDate;
  final String? departureDate;
  final List<Map<String, String>> seatPassengerData;

  const PaymentRouteSuccessScreen({
    Key? key,
    required this.route,
    required this.totalPrice,
    required this.numberOfAdultPassengers,
    required this.numberOfChildPassengers,
    required this.arrivalDate,
    required this.departureDate,
    required this.seatPassengerData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Payment Details",
      showBackButton: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ Success icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check_circle, color: Colors.green, size: 80),
            ),
            const SizedBox(height: 16),
            const Text(
              "Payment Successful!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your route tickets are confirmed.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // ✅ Route details
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.location_on, "From",
                        route.fromCity?.name ?? "Unknown"),
                    _buildDetailRow(
                        Icons.flag, "To", route.toCity?.name ?? "Unknown"),
                    _buildDetailRow(Icons.event, "Departure Date",
                        departureDate ?? "Not set"),
                    _buildDetailRow(
                        Icons.schedule, "Arrival Date", arrivalDate),
                    _buildDetailRow(Icons.people, "Adults",
                        numberOfAdultPassengers.toString()),
                    _buildDetailRow(Icons.child_care, "Children",
                        numberOfChildPassengers.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Tickets list
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tickets",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...seatPassengerData.map((entry) => ListTile(
                          leading:
                              const Icon(Icons.event_seat, color: Colors.blue),
                          title: Text("Seat: ${entry['seatNumber']}"),
                          subtitle:
                              Text("Passenger: ${entry['passengerName']}"),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Price section
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.payment, color: Colors.purple),
                title: const Text("Total Paid",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                trailing: Text(
                  "${totalPrice.toStringAsFixed(2)} BAM",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ✅ Back button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomePageScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.home, color: Colors.white),
              label: const Text(
                "Back to Home",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 22),
          const SizedBox(width: 12),
          Text("$title: ",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
              child: Text(value,
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
