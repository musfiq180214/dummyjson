class CartProduct {
  final String title;
  final String image;
  final double price;
  final int quantity;

  CartProduct({
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  CartProduct copyWith({
    String? title,
    String? image,
    double? price,
    int? quantity,
  }) {
    return CartProduct(
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      title: json['title'],
      image: json['image'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "image": image,
      "price": price,
      "quantity": quantity,
    };
  }
}