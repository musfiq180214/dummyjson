import 'package:dummyjson/core/network/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/product_repository.dart';
import '../domain/product_response_model.dart';

final productRepositoryProvider = Provider<IProductRepository>((ref) {
  final dio = ref.read(dioProvider);
  return ProductRepository(dio);
});

final productListProvider =
    FutureProvider.autoDispose<List<ProductResponseModel>>((ref) async {
      final repo = ref.read(productRepositoryProvider);
      return repo.getProducts();
    });
