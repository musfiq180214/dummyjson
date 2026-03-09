import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:flutter/material.dart';
import '../../../core/navigation/route_names.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String number;
  final String trxId;
  final double amount;

  const PaymentSuccessScreen({
    super.key,
    required this.number,
    required this.trxId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Success Icon
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(.1),
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 30),

              /// Title
              const Text(
                "Payment Successful",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "Your payment has been submitted successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              /// Transaction Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _row("Payment Method", "bKash"),

                    const Divider(height: 20),

                    _row("bKash Number", number),

                    const Divider(height: 20),

                    _row("Transaction ID", trxId),

                    const Divider(height: 20),

                    _row(
                      "Amount",
                      "${amount.toStringAsFixed(2)} BDT",
                      isAmount: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// Go Home Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    AppNavigator.goTo(RouteNames.landing);
                  },
                  child: const Text(
                    "Go Home",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              /// Continue Shopping
              TextButton(
                onPressed: () {
                  AppNavigator.goTo(RouteNames.productList);
                },
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value, {bool isAmount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 15, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isAmount ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
