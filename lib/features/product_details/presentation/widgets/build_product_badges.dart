import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/app_badge.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

Widget buildProductBadges(
  ProductModel product,
  BuildContext context,
  double alpha,
) {
  final l10n = AppLocalizations.of(context);
  if (l10n == null) return const SizedBox.shrink();

  final badges = <Widget>[];

  if (product.hasDiscount) {
    badges.add(
      AppBadge(
        label: '${product.discountPercentage.toInt()}% OFF',
        color: Colors.red,
        backgroundAlpha: alpha,
        borderAlpha: 0.5,
        fontSize: 11,
        letterSpacing: 0.5,
      ),
    );
  }

  if (product.newArrival) {
    badges.add(
      AppBadge(
        label: l10n.newArrival,
        color: Colors.green,
        backgroundAlpha: alpha,
        borderAlpha: 0.5,
        fontSize: 11,
        letterSpacing: 0.5,
      ),
    );
  }

  if (product.bestSeller) {
    badges.add(
      AppBadge(
        label: l10n.bestSeller,
        color: Colors.orange,
        backgroundAlpha: alpha,
        borderAlpha: 0.5,
        fontSize: 11,
        letterSpacing: 0.5,
      ),
    );
  }

  if (product.featured) {
    badges.add(
      AppBadge(
        label: l10n.featured,
        color: AppColors.primary,
        backgroundAlpha: alpha,
        borderAlpha: 0.5,
        fontSize: 11,
        letterSpacing: 0.5,
      ),
    );
  }

  if (product.stockQuantity <= 0) {
    badges.add(
      AppBadge(
        label: 'OUT OF STOCK',
        color: Colors.grey,
        backgroundAlpha: alpha,
        borderAlpha: 0.5,
        fontSize: 11,
        letterSpacing: 0.5,
      ),
    );
  }

  if (badges.isEmpty) return const SizedBox.shrink();

  return Wrap(spacing: 8, runSpacing: 8, children: badges);
}
