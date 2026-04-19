import 'package:cached_network_image/cached_network_image.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:electronics_shop/core/utils/functions/cache_manager.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/wishlist/presentation/widget/build_delete_button.dart';
import 'package:electronics_shop/features/wishlist/presentation/widget/build_product_details.dart';
import 'package:electronics_shop/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WishlistItemCard extends StatelessWidget {
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 10.0;
  static const double _contentPadding = 12.0;
  static const double _spacing = 16.0;

  final ProductModel product;

  const WishlistItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: .15),
            blurRadius: 15,
            spreadRadius: -5,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkShapeClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: .9),
            border: Border.all(color: AppColors.cyan.withValues(alpha: .5), width: 0.5),
          ),
          child: InkWell(
            onTap: () => context.push(AppRoutes.productDetails, extra: product),
            child: Padding(
              padding: const EdgeInsets.all(_contentPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.cyan.withValues(alpha: .3)),
                    ),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Hero(
                        tag: 'wishlist_product_${product.id}',
                        child: CachedNetworkImage(
                          cacheManager: CustomCacheManager.instance,
                          imageUrl: product.imageUrls.isNotEmpty
                              ? product.imageUrls.first.medium
                              : '',
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => const Icon(Icons.image, size: 40),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: _spacing),
                  Expanded(child: buildProductDetails(product)),
                  DeleteButtonFromWishlist(product: product),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
