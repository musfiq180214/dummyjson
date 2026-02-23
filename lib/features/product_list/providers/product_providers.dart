import 'package:dummyjson/core/network/api_client.dart';
import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/features/product_list/data/product_repository.dart';
import 'package:dummyjson/features/product_list/domain/product_response_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository Provider
final productRepoProvider = Provider<IProductRepository>(
  (ref) => ProductRepository(ref.watch(dioProvider)),
);

// Pagination StateNotifier Provider
final productPaginationNotifierProvider =
    StateNotifierProvider.autoDispose<
      ProductPaginationNotifier,
      PaginationState<ProductResponseModel>
    >((ref) => ProductPaginationNotifier(ref.read(productRepoProvider)));

class ProductPaginationNotifier
    extends StateNotifier<PaginationState<ProductResponseModel>> {
  final IProductRepository repository;
  final int perPage;

  ProductPaginationNotifier(this.repository, {this.perPage = 20})
    : super(PaginationState.initial());

  // Fetch next page or refresh
  Future<void> fetchNextPage({bool refresh = false}) async {
    if (state.isLoading || (!state.hasMoreData && !refresh)) return;

    try {
      state = state.copyWith(isLoading: true);

      final pageToFetch = refresh ? 1 : state.currentPage;

      // Fetch data from repository
      final List<ProductResponseModel> newItems = await repository.getProducts(
        perPage,
        pageToFetch,
      );

      // Merge with existing data if not refreshing
      final updatedData = refresh ? newItems : [...state.data, ...newItems];

      state = state.copyWith(
        data: updatedData,
        currentPage: pageToFetch + 1,
        isLoading: false,
        hasMoreData: newItems.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to load products",
      );
    }
  }

  void reset() {
    state = PaginationState.initial();
  }
}
