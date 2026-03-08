import '../domain/cart_product.dart';


abstract class ICartProductRepository {
  List<CartProduct> getCartProducts();
}


class CartProductRepository implements ICartProductRepository {

  @override
  List<CartProduct> getCartProducts() {
    return List.generate(
      10,
          (index) => CartProduct(
        title: "Product ${index + 1}",
        image: "assets/images/product.jpeg",
        price: 20.0 + index,
        quantity: 1,
      ),
    );
  }
}