import 'package:dummyjson/features/product_list/domain/product_response_model.dart';

class ProductSearchResponse {
  final List<Product> products;
  final int? total;
  final int? skip;
  final int? limit;

  ProductSearchResponse({
    required this.products,
    this.total,
    this.skip,
    this.limit,
  });

  factory ProductSearchResponse.fromJson(Map<String, dynamic> json) {
    return ProductSearchResponse(
      products: (json['products'] as List<dynamic>? ?? [])
          .map((e) => Product.fromJson(e))
          .toList(),
      total: json['total'] as int?,
      skip: json['skip'] as int?,
      limit: json['limit'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'products': products.map((e) => e.toJson()).toList(),
    'total': total,
    'skip': skip,
    'limit': limit,
  };
}
