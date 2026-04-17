import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/cart/data/models/cart_item_model.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:electronics_shop/features/cart/presentation/controllers/cart_controller.dart';
import 'package:electronics_shop/features/product_details/presentation/controllers/product_details_controller.dart';



class CyberpunkBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double cut = 12.0;
    path.moveTo(cut, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cut);
    path.lineTo(size.width - cut, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cut);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomIconsRow extends ConsumerWidget {
  final ProductModel product;

  const BottomIconsRow({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cartState = ref.watch(cartControllerProvider);
    final cartNotifier = ref.watch(cartControllerProvider.notifier);
    final detailsState = ref.watch(productDetailsControllerProvider(product));
    final detailsNotifier = ref.watch(
      productDetailsControllerProvider(product).notifier,
    );
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 95,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.15),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
        border: Border(
          top: BorderSide(color: AppColors.cyan.withValues(alpha: .5), width:.2),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCartActionArea(
              context,
              ref,
              theme,
              cartNotifier,
              detailsState,
              detailsNotifier,
              l10n,
              cartState,
              isDark,
            ),
          ),
          const SizedBox(width: 12),
          _buildWishlistButton(theme, detailsState, detailsNotifier, isDark),
        ],
      ),
    );
  }

  Widget _buildCartActionArea(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    CartController cartNotifier,
    ProductDetailsState detailsState,
    ProductDetailsController detailsNotifier,
    AppLocalizations l10n,
    dynamic cartState,
    bool isDark,
  ) {
    final item = cartNotifier.getCartItem(
      product,
      selectedColor: detailsState.selectedColor,
      selectedSize: detailsState.selectedSizeObject?.size,
    );

    return item != null
        ? _buildQuantityControls(theme, cartNotifier, item, l10n, isDark)
        : _buildAddToCartButton(
            detailsState,
            detailsNotifier,
            cartNotifier,
            l10n,
            cartState,
            isDark,
          );
  }

  Widget _buildAddToCartButton(
    ProductDetailsState detailsState,
    ProductDetailsController detailsNotifier,
    CartController cartNotifier,
    AppLocalizations l10n,
    dynamic cartState,
    bool isDark,
  ) {
    final isPriceZero = detailsNotifier.getDisplayEffectivePrice(product) <= 0;
    final buttonColor = isPriceZero ? Colors.grey : AppColors.cyan;

    return GestureDetector(
      onTap: isPriceZero
          ? null
          : () {
              cartNotifier.addToCart(
                product,
                selectedColor: detailsState.selectedColor,
                selectedSize: detailsState.selectedSizeObject?.size,
              );
            },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: buttonColor.withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipPath(
          clipper: CyberpunkBottomClipper(),
          child: Container(
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: buttonColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPriceZero ? Icons.mail_rounded : Icons.shopping_bag_rounded,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  (isPriceZero ? l10n.contactUs : l10n.addToCart).toUpperCase(),
                  style:  TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    letterSpacing: 1.2,
                    shadows: [
                      BoxShadow(
                        offset: Offset(-0.0, 0.0),
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls(
    ThemeData theme,
    CartController cartNotifier,
    CartItemModel item,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkBottomClipper(),
        child: Container(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
          child: Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.cyan, width: 3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    item.quantity > 1 ? Icons.remove_rounded : Icons.delete_rounded,
                    color: item.quantity > 1 ? AppColors.cyan : Colors.redAccent,
                  ),
                  onPressed: () => cartNotifier.decreaseQuantity(item),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    item.quantity.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.cyan,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_rounded, color: AppColors.cyan),
                  onPressed: () => cartNotifier.increaseQuantity(item),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistButton(
    ThemeData theme,
    ProductDetailsState detailsState,
    ProductDetailsController detailsNotifier,
    bool isDark,
  ) {
    final isInWishlist = detailsState.isInWishlist;

    return Container(
      decoration: BoxDecoration(
        boxShadow: isInWishlist
            ? [
                BoxShadow(
                  color: AppColors.magenta.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ]
            : [],
      ),
      child: ClipPath(
        clipper: CyberpunkBottomClipper(),
      
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: isInWishlist ? AppColors.magenta : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
          ),
          child: IconButton(
            icon: Icon(
              isInWishlist ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isInWishlist ? Colors.red : (isDark ? AppColors.cyan : Colors.black54),
              size: 24,
              shadows:  isInWishlist ? [
                BoxShadow(
                offset: Offset(-2.0, 2.0),
                color: Colors.black.withValues(alpha: 0.8),
                 blurRadius: 10),
                BoxShadow(
                offset: Offset(-0.0, 0.0),
                color: Colors.black.withValues(alpha: 0.8),
                 blurRadius: 10)
                 ] : [],
            ),
            onPressed: () => detailsNotifier.toggleWishlist(product),
          ),
        ),
      ),
    );
  }
}

