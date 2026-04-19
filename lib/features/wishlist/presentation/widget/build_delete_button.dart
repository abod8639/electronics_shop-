import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/functions/handle_delete_from_wishlist.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double _iconSize = 24.0;

class DeleteButtonFromWishlist extends ConsumerWidget {
  final ProductModel product;
  const DeleteButtonFromWishlist({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      label: 'Remove ${product.getLocalizedName(locale: 'en')} from wishlist',
      button: true,
      child: IconButton(
        icon: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.error.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.delete_sweep_rounded,
            size: _iconSize,
            color: AppColors.error,
          ),
        ),
        onPressed: () => handleDeleteFromWishlist(context, ref, product),
        tooltip: 'Remove from Wishlist',
      ),
    );
  }
}
