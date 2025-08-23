import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/model/organized_trip/organized_trip.dart';
import 'package:travel_mobile/providers/account_provider.dart';
import 'package:travel_mobile/providers/trip_ticket_provider.dart';
import 'package:travel_mobile/screens/organized_trip/organized_trip_list_screen.dart';
import 'package:travel_mobile/screens/trip_reservation_view/trip_reservation_view.dart';

class PaymentScreen extends StatefulWidget {
  final OrganizedTripModel? organizedTrip;
  final List<Map<String, String>> seatPassengerData;
  final int numberOfPassengers;
  final double totalPrice;

  const PaymentScreen({
    Key? key,
    this.organizedTrip,
    required this.seatPassengerData,
    required this.numberOfPassengers,
    required this.totalPrice,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int get stripeAmount => widget.totalPrice.round();

  bool get isPayButtonEnabled =>
      widget.numberOfPassengers > 0 && widget.totalPrice > 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (_) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        onCreditCardModelChange: onCreditCardModelChange,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                      ),
                      const SizedBox(height: 20),
                      _buildSeatSummary(),
                      const SizedBox(height: 20),
                      _buildPriceSection(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isPayButtonEnabled
                            ? () async {
                                if (formKey.currentState!.validate()) {
                                  bool paymentSuccess = await _makePayment();
                                  if (paymentSuccess) {
                                    _buyTicket(context);
                                  } else {
                                    _showPaymentErrorDialog(context);
                                  }
                                } else {
                                  _showValidationErrorDialog(context);
                                }
                              }
                            : null,
                        child: const Text('Pay Now'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Passenger Seats", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        ...widget.seatPassengerData.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Icon(Icons.event_seat,
                    size: 20, color: Colors.blueAccent),
                const SizedBox(width: 6),
                Text(
                  entry['seatNumber'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.person, size: 20, color: Colors.green),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    entry['passengerName'] ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Total Price", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Text(
          "${widget.totalPrice.toStringAsFixed(2)} BAM",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Future<bool> _makePayment() async {
    try {
      List<String> parts = expiryDate.split('/');
      var _tripTicketProvider = context.read<TripTicketProvider>();

      var request = {
        'cardNumber': cardNumber,
        'month': parts[0],
        'year': parts[1],
        'cvc': cvvCode,
        'cardHolderName': cardHolderName,
        'totalPrice': stripeAmount,
        'personCount': widget.numberOfPassengers,
      };

      var result = await _tripTicketProvider.pay(request);
      return result;
    } catch (e) {
      return false;
    }
  }

  void _buyTicket(BuildContext context) async {
    try {
      var _tripTicketProvider = context.read<TripTicketProvider>();
      var currentUser = await context.read<AccountProvider>().getCurrentUser();

      await _tripTicketProvider.insert({
        'passengerId': currentUser.nameid,
        'price': widget.totalPrice,
        'tripId': widget.organizedTrip!.id,
        'numberOfPassengers': widget.numberOfPassengers,
        'seatNumbers': widget.seatPassengerData
            .map((entry) => {
                  'seatNumber':
                      entry['seatNumber'] ?? entry['seat'], // just in case
                  'passengerName': entry['passengerName'] ?? entry['name'],
                })
            .toList(),
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PaymentSuccessScreen(
            trip: widget.organizedTrip!,
            totalPrice: widget.totalPrice,
            numberOfPassengers: widget.numberOfPassengers,
            seatPassengerData: widget.seatPassengerData,
          ),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _showPaymentErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Payment Error"),
        content: const Text("There was an error processing your payment."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showValidationErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Validation Error"),
        content:
            const Text("Please ensure all fields are filled out correctly."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
