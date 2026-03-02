import 'package:dummyjson/core/network/api_client.dart';
import 'package:dummyjson/features/multi_screen_order_placement/data/drop_down_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dropdownRepositoryProvider = Provider<IDropdownRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DropdownRepository(dio);
});

final dropdownDataProvider =
    FutureProvider.family<List<Map<String, dynamic>>, DropdownRequest>((
      ref,
      request,
    ) async {
      final repo = ref.watch(dropdownRepositoryProvider);
      return repo.fetchDropdown(
        request.endpoint,
        queryParameters: request.queryParameters,
      );
    });

class DropdownRequest {
  final String endpoint;
  final Map<String, dynamic>? queryParameters;

  const DropdownRequest({required this.endpoint, this.queryParameters});
}
