import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_button.dart';
import 'package:electronics_shop/features/cart/data/models/cart_item_model.dart';
import 'package:electronics_shop/features/cart/presentation/controllers/cart_controller.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/product_details/presentation/controllers/product_details_controller.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      height: 90,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.1),
            offset: const Offset(0, -5),
            blurRadius: 15,
          ),
        ],
        border: Border(
          top: BorderSide(
            color: AppColors.cyan.withValues(alpha: isDark ? 0.3 : 0.15),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          const SizedBox(width: 16),

          _buildWishlistButton(theme, detailsState, detailsNotifier, isDark, product),
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
    final accentColor = isPriceZero ? Colors.grey : AppColors.cyan;

    return InkWell(
      onTap: isPriceZero
          ? null
          : () => cartNotifier.addToCart(
                product,
                selectedColor: detailsState.selectedColor,
                selectedSize: detailsState.selectedSizeObject?.size,
              ),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.2),
              blurRadius: 12,
              spreadRadius: -2,
            ),
          ],
        ),
        child: ClipPath(
          clipper: CyberpunkBottomClipper(),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor, accentColor.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPriceZero ? Icons.mail_outline_rounded : Icons.shopping_cart_checkout_rounded,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  (isPriceZero ? l10n.contactUs : l10n.addToCart).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    letterSpacing: 1.5,
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
    final cyan = AppColors.cyan;
    return Container(
      height: 55,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: cyan.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkBottomClipper(),
        child: Container(
          color: isDark ? theme.colorScheme.surface : Colors.black.withValues(alpha: 0.05),
          child: Stack(
            children: [
              BackGrid(accentColor: cyan),
              Container(
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: cyan, width: 3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: item.quantity > 1 ? Icons.remove_rounded : Icons.delete_outline_rounded,
                      color: item.quantity > 1 ? cyan : AppColors.error,
                      onPressed: () => cartNotifier.decreaseQuantity(item),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          vertical: BorderSide(color: cyan.withValues(alpha: 0.2)),
                        ),
                      ),
                      child: Text(
                        item.quantity.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: isDark ? cyan : Colors.black87,
                          shadows: [
                            if (isDark) Shadow(color: cyan.withValues(alpha: 0.5), blurRadius: 4),
                          ],
                        ),
                      ),
                    ),
                    _buildControlButton(
                      icon: Icons.add_rounded,
                      color: cyan,
                      onPressed: () => cartNotifier.increaseQuantity(item),
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

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: 22),
      onPressed: onPressed,
      splashRadius: 24,
    );
  }

  Widget _buildWishlistButton(
    ThemeData theme,
    ProductDetailsState detailsState,
    ProductDetailsController detailsNotifier,
    bool isDark,
    ProductModel product,
  ) {
    final isInWishlist = detailsState.isInWishlist;
    final magenta = AppColors.magenta;
    final cyan = AppColors.cyan;
    final accent = isInWishlist ? magenta : (isDark ? cyan : Colors.black54);

    return  CyberpunkButton(
            size: 55,
            icon: Icon(isInWishlist ? Icons.favorite_rounded : Icons.favorite_border, color: AppColors.magenta),
            tooltip:"",
            onTap: () => detailsNotifier.toggleWishlist(product),
          );
    
    //  InkWell(
    //   onTap: 
    //   child: Container(
    //     width: 55,
    //     height: 55,
    //     decoration: BoxDecoration(
    //       boxShadow: [
    //         BoxShadow(
    //           color: accent.withValues(alpha: isInWishlist ? 0.3 : 0.1),
    //           blurRadius: 12,
    //           spreadRadius: -2,
    //         ),
    //       ],
    //     ),
    //     child: ClipPath(
    //       clipper: CyberpunkBottomClipper(),
    //       child: Container(
    //         color: isDark ? theme.colorScheme.surface : Colors.black.withValues(alpha: 0.05),
    //         child: Stack(
    //           alignment: Alignment.center,
    //           children: [
    //            BackGrid(accentColor: accent),
    //             Icon(
    //               isInWishlist ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
    //               color: isInWishlist ? Colors.redAccent : accent,
    //               size: 26,
    //               shadows: [
    //                 if (isInWishlist)
    //                   Shadow(color: Colors.redAccent.withValues(alpha: 0.5), blurRadius: 8),
    //               ],
    //             ),

    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

