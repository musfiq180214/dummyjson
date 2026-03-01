import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/core/utils/sizes.dart';
import 'package:dummyjson/core/widgets/global_appbar.dart';
import 'package:dummyjson/features/product_list/domain/product_response_model.dart';
import 'package:dummyjson/features/product_list/widget/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  OverlayEntry? _overlayEntry;

  void _showImagePreview() {
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onLongPressEnd: (_) => _hideImagePreview(),
        child: Material(
          color: Colors.white,
          child: Center(
            child: InteractiveViewer(
              child: Image.network(
                widget.product.thumbnail ?? "",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideImagePreview() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideImagePreview();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: GlobalAppBar(title: context.t.product, canGoBack: true),
      body: SingleChildScrollView(
        child: Container(
          margin: AppSpacing.marginL,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔥 Image with Long Press Preview
              GestureDetector(
                onLongPressStart: (_) => _showImagePreview(),
                onLongPressEnd: (_) => _hideImagePreview(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.thumbnail ?? "",
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              AppSpacing.verticalSpaceM,

              /// Product Info Card
              Card(
                child: Container(
                  decoration: BoxDecoration(
                    color: seaGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: AppSpacing.paddingL,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t.product_details,
                        style: AppTextStyles.bodyS.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      AppSpacing.verticalSpaceM,

                      _productInfo(
                        icon: CupertinoIcons.money_dollar,
                        title: "Price",
                        value: product.price != null
                            ? "\$${product.price}"
                            : "N/A",
                      ),

                      _productInfo(
                        icon: Icons.discount_outlined,
                        title: "Discount",
                        value: product.discountPercentage?.toString() ?? "N/A",
                      ),

                      _productInfo(
                        icon: Icons.star_border,
                        title: "Rating",
                        value: product.rating?.toString() ?? "N/A",
                      ),

                      _productInfo(
                        icon: Icons.inventory_2_outlined,
                        title: "Stock",
                        value: product.stock?.toString() ?? "N/A",
                      ),
                    ],
                  ),
                ),
              ),

              AppSpacing.verticalSpaceXL,

              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.amber,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productInfo({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          AppSpacing.horizontalSpaceS,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.label),
                AppSpacing.verticalSpaceXS,
                Text(value, style: AppTextStyles.label),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
