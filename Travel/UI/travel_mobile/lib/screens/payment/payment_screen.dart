import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';
import 'package:travel_mobile/model/organized_trip/organized_trip.dart';
import 'package:travel_mobile/providers/account_provider.dart';
import 'package:travel_mobile/providers/trip_ticket_provider.dart';
import 'package:travel_mobile/screens/organized_trip/organized_trip_details_screen.dart';
import 'package:travel_mobile/screens/organized_trip/organized_trip_list_screen.dart';

class PaymentScreen extends StatefulWidget {
  final OrganizedTripModel? organizedTrip;

  const PaymentScreen({Key? key, this.organizedTrip}) : super(key: key);

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
  int numberOfPeople = 1;

  double get unitPrice => widget.organizedTrip?.price ?? 0;
  int get maxSeats => widget.organizedTrip?.availableSeats ?? 1;
  bool get hasDiscount => numberOfPeople >= 5;

  double get totalPriceBeforeDiscount => unitPrice * numberOfPeople;

  double get totalPriceAfterDiscount =>
      hasDiscount ? totalPriceBeforeDiscount * 0.85 : totalPriceBeforeDiscount;

  int get stripeAmount => totalPriceAfterDiscount.round();

  bool get isPayButtonEnabled =>
      numberOfPeople >= 1 &&
      numberOfPeople <= maxSeats &&
      totalPriceAfterDiscount > 0;

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
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
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
                      _buildPersonSelector(),
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

  Widget _buildPersonSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Number of People", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Row(
          children: [
            IconButton(
              onPressed: numberOfPeople > 1
                  ? () => setState(() => numberOfPeople--)
                  : null,
              icon: const Icon(Icons.remove_circle),
            ),
            Text(
              numberOfPeople.toString(),
              style: const TextStyle(fontSize: 18),
            ),
            IconButton(
              onPressed: () {
                if (numberOfPeople < maxSeats) {
                  setState(() => numberOfPeople++);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "You can't select more than $maxSeats people — only that many seats are available."),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add_circle),
            ),
          ],
        ),
        if (hasDiscount)
          const Text(
            "✅ You get a 15% discount for 5 or more people!",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
          ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Total Price", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          children: [
            if (hasDiscount)
              Text(
                "${totalPriceBeforeDiscount.toStringAsFixed(2)} €",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            const SizedBox(width: 10),
            Text(
              "${totalPriceAfterDiscount.toStringAsFixed(2)} €",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ],
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
        'personCount': numberOfPeople,
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
        'price': totalPriceAfterDiscount,
        'tripId': widget.organizedTrip!.id,
        'numberOfPassengers': numberOfPeople,
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Success"),
          content: const Text(
              "You have successfully purchased a ticket for the trip."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrganizedTripListScreen())),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
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
      builder: (BuildContext context) => AlertDialog(
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
      builder: (BuildContext context) => AlertDialog(
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
