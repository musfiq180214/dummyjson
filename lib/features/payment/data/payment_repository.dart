import 'package:dummyjson/features/payment/domain/payment.dart';

abstract class IPaymentRepository {
  Future<bool> submitPayment(Payment payment);
}

class PaymentRepository implements IPaymentRepository {
  @override
  Future<bool> submitPayment(Payment payment) async {
    await Future.delayed(const Duration(seconds: 2));

    // simulate success
    return true;
  }
}
