import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/payment_repository.dart';

import '../domain/payment.dart';

final paymentRepositoryProvider = Provider<IPaymentRepository>((ref) {
  return PaymentRepository();
});

class PaymentNotifier extends StateNotifier<AsyncValue<bool?>> {
  PaymentNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> submitPayment(Payment payment) async {
    state = const AsyncValue.loading();

    try {
      final repo = ref.read(paymentRepositoryProvider);

      final result = await repo.submitPayment(payment);

      state = AsyncValue.data(result);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final paymentProvider =
    StateNotifierProvider<PaymentNotifier, AsyncValue<bool?>>((ref) {
      return PaymentNotifier(ref);
    });
