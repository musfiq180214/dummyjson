class Product {
  int? id;
  String? title;
  String? description;
  String? category;
  double? price;
  double? discountPercentage;
  double? rating;
  int? stock;
  List<String>? tags;
  int? weight;
  String? thumbnail;
  String? warrantyInformation;

  Product({
    this.id,
    this.title,
    this.description,
    this.category,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.tags,
    this.weight,
    this.thumbnail,
    this.warrantyInformation,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return Product();

    return Product(
      id: json['id']?.toInt(),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      category: json['category'].toString(),

      rating: (json['rating'] as num?)?.toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toInt(),
      thumbnail: json['thumbnail'].toString(),
      warrantyInformation: json["warrantyInformation"].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'price': price,
    'discountPercentage': discountPercentage,
    'rating': rating,
    'stock': stock,
    'tags': tags,
    'weight': weight,
    'thumbnail': thumbnail,
    "warrentyInformation": warrantyInformation,
  };
}

class ProductResponseModel {
  int? id;
  Product? product;

  ProductResponseModel({this.id, this.product});

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      id: json['id'] as int?,
      product: Product.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'product': product?.toJson()};
}

List<ProductResponseModel> productListFromJson(List<dynamic> jsonList) {
  return jsonList.map((json) => ProductResponseModel.fromJson(json)).toList();
}
