import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:dummyjson/core/provider/secureStorageProvider.dart';
import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/core/utils/sizes.dart';
import 'package:dummyjson/core/widgets/global_appbar.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:dummyjson/features/product_list/widget/product_card.dart';
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
    final loginState = ref.watch(loginProvider);

    return Scaffold(
      appBar: GlobalAppBar(
        title: context.t.product_search,
        canGoBack: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.green),
            onSelected: (value) async {
              if (value == 'logout') {
                await _handleLogout(context, ref);
              } else if (value == 'profile') {
                loginState.when(
                  data: (user) {
                    if (user != null) {
                      AppNavigator.navigatorKey.currentState!.pushNamed(
                        RouteNames.profile,
                        arguments: user,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("User data not available"),
                        ),
                      );
                    }
                  },
                  loading: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Loading user data...")),
                    );
                  },
                  error: (err, st) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Error fetching user data")),
                    );
                  },
                );
              } else if (value == 'others') {
                AppLogger.i("Others clicked");
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'logout', child: Text('Logout')),
              PopupMenuItem(value: 'profile', child: Text('Profile')),
              PopupMenuItem(value: 'others', child: Text('Others')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: context.t.search_product,
                border: const OutlineInputBorder(),
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
                ? Center(child: Text(context.t.type_to_search))
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

                          return Container(
                            margin: EdgeInsets.only(
                              bottom: AppSpacing.marginS.bottom,
                            ),
                            child: InkWell(
                              onTap: () {
                                AppNavigator.pushTo(
                                  RouteNames.productDetails,
                                  extra: product,
                                );
                              },
                              child: ProductCard(
                                title: product?.title ?? "Unknown Product",
                                description:
                                    product?.description ?? "No description",
                                category: product?.category ?? "Unknown",
                                price: product?.price != null
                                    ? "\$${product!.price}"
                                    : "N/A",
                                rating: product?.rating != null
                                    ? product!.rating.toString()
                                    : "N/A",
                                stock: product?.stock?.toString() ?? "N/A",
                                thumbnail: product?.thumbnail ?? "",
                                warrentyInformation:
                                    product?.warrantyInformation ?? "N/A",
                                onTap: () {
                                  AppNavigator.pushTo(
                                    RouteNames.productDetails,
                                    extra:
                                        product, // pass the Product object via 'extra'
                                  );
                                },
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

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(secureStorageProvider).deleteAll();
    AppLogger.i("Logging Out");

    AppNavigator.goTo(RouteNames.login);
  }
}
