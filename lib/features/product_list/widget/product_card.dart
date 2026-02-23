import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final String category;
  final String price;
  final String rating;
  final String stock;
  final String thumbnail;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: AppSpacing.paddingM,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  thumbnail,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(width: 100, height: 100, color: grey),
                ),
              ),
              AppSpacing.horizontalSpaceM,
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyM.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.verticalSpaceXS,
                    Text(
                      description,
                      style: AppTextStyles.bodyS,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.verticalSpaceS,
                    Row(
                      children: [
                        Text("Category: ", style: AppTextStyles.label),
                        Text(category, style: AppTextStyles.bodyS),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Price: ", style: AppTextStyles.label),
                        Text(price, style: AppTextStyles.bodyS),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Rating: ", style: AppTextStyles.label),
                        Text(rating, style: AppTextStyles.bodyS),
                        AppSpacing.horizontalSpaceS,
                        Text("Stock: ", style: AppTextStyles.label),
                        Text(stock, style: AppTextStyles.bodyS),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
