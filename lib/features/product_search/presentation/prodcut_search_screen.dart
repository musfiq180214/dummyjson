import 'package:dummyjson/core/widgets/global_appbar.dart';
import 'package:dummyjson/features/product_search/providers/product_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductSearchScreen extends ConsumerStatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  ConsumerState<ProductSearchScreen> createState() =>
      _ProductSearchScreenState();
}

class _ProductSearchScreenState extends ConsumerState<ProductSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(productSearchProvider(searchQuery));

    return Scaffold(
      appBar: GlobalAppBar(title: "Search Product", cangoBack: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Search product...",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          Expanded(
            child: searchQuery.isEmpty
                ? const Center(child: Text("Type to search"))
                : searchAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text("Error: $error")),
                    data: (response) {
                      final products = response.products;

                      if (products.isEmpty) {
                        return const Center(child: Text("No products found"));
                      }

                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ListTile(
                              title: Text(product.title ?? ''),
                              subtitle: Text(product.description ?? ''),
                              trailing: Text(
                                "\$${product.price?.toStringAsFixed(2) ?? ''}",
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
