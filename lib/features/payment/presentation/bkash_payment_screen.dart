import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:dummyjson/core/utils/custom_dialog.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/core/widgets/global_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cart/providers/cart_providers.dart';
import '../domain/payment.dart';
import '../providers/payment_provider.dart';

class BkashPaymentScreen extends ConsumerStatefulWidget {
  const BkashPaymentScreen({super.key});

  @override
  ConsumerState<BkashPaymentScreen> createState() => _BkashPaymentScreenState();
}

class _BkashPaymentScreenState extends ConsumerState<BkashPaymentScreen> {
  final trxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final paymentState = ref.watch(paymentProvider);

    final amount = cartNotifier.grandTotal;

    return Scaffold(
      appBar: GlobalAppBar(title: "bKash Payment", canGoBack: true),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Send Money To:", style: TextStyle(fontSize: 16)),

            const SizedBox(height: 5),

            const Text(
              "017XXXXXXXX",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Amount: ${amount.toStringAsFixed(2)} BDT",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            const Text("Enter bKash Transaction ID"),

            const SizedBox(height: 8),

            TextField(
              controller: trxController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "TrxID",
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: paymentState.isLoading
                    ? null
                    : () async {
                        final trx = trxController.text;

                        if (trx.isEmpty) {
                          showCustomSnackBar(
                            context,
                            message: "Enter TrxID",
                            type: MessageType.error,
                          );
                          return;
                        }

                        if (trx.length < 10) {
                          showCustomSnackBar(
                            context,
                            message:
                                "Invalid TrxID(must contain 10 characters or more)",
                            type: MessageType.error,
                          );
                          return;
                        }

                        final payment = Payment(
                          amount: amount,
                          trxId: trx,
                          method: "bkash",
                        );

                        await ref
                            .read(paymentProvider.notifier)
                            .submitPayment(payment);

                        final result = ref.read(paymentProvider);

                        result.whenData((success) {
                          if (success == true) {
                            showCustomSnackBar(
                              context,
                              message: "Payment Submitted",
                              type: MessageType.success,
                            );

                            AppNavigator.pushTo(
                              RouteNames.paymentSuccess,
                              extra: {
                                "number": "017XXXXXXXX",
                                "trxId": trx,
                                "amount": amount,
                              },
                            );
                          }
                        });
                      },

                child: paymentState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Submit Payment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
