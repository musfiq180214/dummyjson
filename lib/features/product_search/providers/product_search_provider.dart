import 'package:dummyjson/core/network/api_client.dart';
import 'package:dummyjson/features/product_search/data/product_search_repository.dart';
import 'package:dummyjson/features/product_search/domain/product_search_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productSearchRepositoryProvider = Provider<IProductSearchRepository>((
  ref,
) {
  final dio = ref.read(dioProvider);
  return ProductSearchRepository(dio);
});

final productSearchProvider = FutureProvider.family
    .autoDispose<ProductSearchResponse, String>((ref, query) async {
      if (query.isEmpty) {
        return ProductSearchResponse(products: []);
      }

      final repo = ref.read(productSearchRepositoryProvider);
      return repo.searchProducts(query);
    });
