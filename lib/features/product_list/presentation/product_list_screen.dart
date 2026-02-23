import 'package:dummyjson/features/product_list/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);

    // Fetch first page after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productPaginationNotifierProvider.notifier).fetchNextPage();
    });
  }

  void _onScroll() {
    final controller = _scrollController;
    if (!controller.hasClients) return;

    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;

    if (currentScroll >= (maxScroll - 100)) {
      final notifier = ref.read(productPaginationNotifierProvider.notifier);
      final state = ref.read(productPaginationNotifierProvider);

      if (!state.isLoading && state.hasMoreData) {
        notifier.fetchNextPage();
      }
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productPaginationNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(productPaginationNotifierProvider.notifier)
              .fetchNextPage(refresh: true);
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount:
              productState.data.length + (productState.hasMoreData ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < productState.data.length) {
              final product = productState.data[index];

              return ListTile(
                title: Text(product.product?.title ?? ""),
                subtitle: Text("\$${product.product?.price}"),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
