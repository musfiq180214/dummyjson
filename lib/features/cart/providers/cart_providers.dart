import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/cart_repository.dart';
import '../domain/cart_product.dart';

final cartRepositoryProvider = Provider<ICartProductRepository>((ref) {
  return CartProductRepository();
});


class CartNotifier extends StateNotifier<List<CartProduct>> {
  CartNotifier(this.ref) : super([]) {
    loadProducts();
  }

  final Ref ref;

  double discount = 0;

  void loadProducts() {
    final repo = ref.read(cartRepositoryProvider);
    state = repo.getCartProducts();
  }

  void increaseQuantity(int index) {
    final product = state[index];

    final updated = product.copyWith(
      quantity: product.quantity + 1,
    );

    state = [...state]..[index] = updated;
  }

  void decreaseQuantity(int index) {
    final product = state[index];

    if (product.quantity == 1) {
      removeProduct(index);
      return;
    }

    final updated = product.copyWith(
      quantity: product.quantity - 1,
    );

    state = [...state]..[index] = updated;
  }

  void removeProduct(int index) {
    final newList = [...state]..removeAt(index);
    state = newList;
  }

  void setDiscount(double value) {
    discount = value;
    state = [...state]; // trigger rebuild
  }

  double get totalAmount {
    return state.fold(
      0,
          (sum, item) => sum + (item.price * item.quantity),
    );
  }

  double get grandTotal {
    return totalAmount - discount;
  }
}

final cartProvider =
StateNotifierProvider<CartNotifier, List<CartProduct>>((ref) {
  return CartNotifier(ref);
});