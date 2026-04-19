import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';

const double _titleFontSize = 14.0;
const double _priceFontSize = 16.0;
const int _maxTitleLines = 2;

Widget buildProductDetails(ProductModel product) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final locale = Localizations.localeOf(context).languageCode;
      final productName = product.getLocalizedName(locale: locale);
      final magentaColor = const Color(0xFFFF00F7);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Product Name
          Text(
            productName.toUpperCase(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: _titleFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.cyan,
              fontFamily: 'monospace',
            ),
            maxLines: _maxTitleLines,
            overflow: TextOverflow.ellipsis,
            semanticsLabel: productName,
          ),
          const SizedBox(height: 8.0),

          // Product Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${product.baseEffectivePrice.toStringAsFixed(2)} LE',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: _priceFontSize,
                  color: AppColors.priceColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  shadows: [
                    Shadow(
                      color: magentaColor.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              if (product.hasDiscount) ...[
                const SizedBox(width: 8),
                Text(
                  product.price.toStringAsFixed(2),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    decoration: TextDecoration.lineThrough,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ],
      );
    },
  );
}
