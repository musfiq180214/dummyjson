import 'package:dummyjson/core/widgets/global_appbar.dart';

import 'package:dummyjson/features/product_list/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: GlobalAppBar(title: "Product List", cangoBack: false),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text("Error: ${error.toString()}")),
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text("No Products Found"));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].product;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(product?.title ?? "No Title"),
                  subtitle: Text(product?.description ?? "No Description"),
                  leading: CircleAvatar(
                    child: Text(product?.id?.toString() ?? ""),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
