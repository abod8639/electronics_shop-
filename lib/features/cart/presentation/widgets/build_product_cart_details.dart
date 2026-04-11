import 'package:electronics_shop/core/utils/components/color_variant_image.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/product_color_selector.dart';
import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/cart/data/models/cart_item_model.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

const double _titleFontSize = 18.0;
const double _priceFontSize = 16.0;
const int _maxTitleLines = 2;

Widget buildProductCartDetails(CartItemModel item) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Brand
          if (item.product.brand != null)
            Text(
              item.product.brand!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 4.0),

          // Product Name
          Text(
            item.product.getLocalizedName(
              locale: AppLocalizations.of(context)!.localeName,
            ),
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: _titleFontSize,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: _maxTitleLines,
            overflow: TextOverflow.ellipsis,
            semanticsLabel: item.product.getLocalizedName(
              locale: AppLocalizations.of(context)!.localeName,
            ),
          ),

          // Selected Flavor
          if (item.selectedColor != null && item.selectedColor!.isNotEmpty)
            Row(
              children: [
                selectedValue(
                  title: AppLocalizations.of(context)!.color,
                  value: item.selectedColor!,
                  item: item,
                ),

                const Spacer(),

                ColorVariantImage(
                  shadow: false,
                  width: 90,
                  height: 30,
                  isSelected: false,
                  baseColor: AppColors.primary,
                  details: getColorDetails(item.selectedColor!),
                ),
              ],
            ),

          // Selected Size
          if (item.selectedSize != null && item.selectedSize!.isNotEmpty)
            selectedValue(
              title: AppLocalizations.of(context)!.size,
              value: item.selectedSize!,
              item: item,
            ),

          const SizedBox(height: 8.0),

          // Product Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${item.product.baseEffectivePrice.toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: _priceFontSize,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                '\$${item.product.basePrice.toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: _priceFontSize,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: 5),
            ],
          ),

          const SizedBox(height: 4.0),

          // Total Price (if quantity > 1)
          if (item.quantity > 1)
            Text(
              'Total: \$${item.subtotal.toStringAsFixed(2)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      );
    },
  );
}

Builder selectedValue({
  required String title,
  required String value,
  required CartItemModel item,
  Color? color,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          children: [
            Text(
              "$title: ",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              value,
              // '${item.selectedFlavor}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: color ?? AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    },
  );
}
