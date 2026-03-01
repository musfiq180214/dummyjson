import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:dummyjson/core/provider/secureStorageProvider.dart';
import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/core/utils/loader.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/core/utils/sizes.dart';
import 'package:dummyjson/core/widgets/global_appbar.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:dummyjson/features/product_list/providers/product_providers.dart';
import 'package:dummyjson/features/product_list/widget/product_card.dart';
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
      ref
          .read(productPaginationNotifierProvider.notifier)
          .fetchNextPage(refresh: false);
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

  void _reloadProducts() {
    final notifier = ref.read(productPaginationNotifierProvider.notifier);
    notifier.fetchNextPage(refresh: true);
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
    final loginState = ref.watch(loginProvider);

    return Scaffold(
      appBar: GlobalAppBar(
        title: context.t.product_list,
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
      body: Container(
        padding: AppSpacing.paddingL,
        child: productState.isLoading && productState.data.isEmpty
            ? loader()
            : CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _reloadProducts,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              primaryColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                context.t.refresh,
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(Icons.refresh, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (productState.data.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text("No product available.")),
                    ),

                  SliverList(
                    delegate: SliverChildListDelegate(
                      productState.data.map((productWrapper) {
                        final product = productWrapper.product;

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
                      }).toList(),
                      addAutomaticKeepAlives: true,
                    ),
                  ),
                ],
              ),
        // : RefreshIndicator(
        //     onRefresh: () async {
        //       await ref
        //           .read(productPaginationNotifierProvider.notifier)
        //           .fetchNextPage(refresh: true);
        //     },
        //     child: ListView.builder(
        //       controller: _scrollController,
        //       itemCount:
        //           productState.data.length +
        //           (productState.hasMoreData ? 1 : 0),
        //       itemBuilder: (context, index) {
        //         if (index < productState.data.length) {
        //           final product = productState.data[index];

        //           return ListTile(
        //             title: Text(product.product?.title ?? ""),
        //             subtitle: Text("\$${product.product?.price}"),
        //           );
        //         } else {
        //           return const Padding(
        //             padding: EdgeInsets.all(16),
        //             child: Center(child: CircularProgressIndicator()),
        //           );
        //         }
        //       },
        //     ),
        //   ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(secureStorageProvider).deleteAll();
    AppLogger.i("Logging Out");

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.login,
      (route) => false,
    );
  }
}
