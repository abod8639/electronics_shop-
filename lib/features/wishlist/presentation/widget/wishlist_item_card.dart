import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/wishlist/presentation/widget/build_delete_button.dart';
import 'package:electronics_shop/features/wishlist/presentation/widget/build_product_details.dart';
import 'package:electronics_shop/features/wishlist/presentation/widget/build_product_image.dart';
import 'package:electronics_shop/routes/routes.dart';

class WishlistItemCard extends StatelessWidget {
  static const double _borderRadius = 12.0;
  static const double _cardElevation = 2.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;
  static const double _contentPadding = 12.0;
  static const double _spacing = 16.0;

  final ProductModel product;

  const WishlistItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return Card(
      color: const Color.fromARGB(133, 30, 30, 30),
      margin: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      elevation: _cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: InkWell(
        onTap: () => context.push(AppRoutes.productDetails, extra: product),
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(_contentPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildProductImage(product),
              const SizedBox(width: _spacing),
              Expanded(child: buildProductDetails(product)),
              DeleteButtonFromWishlist(product: product),
            ],
          ),
        ),
      ),
    );
  }
}
