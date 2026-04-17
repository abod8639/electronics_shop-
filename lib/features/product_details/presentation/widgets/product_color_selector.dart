import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/core/utils/components/color_variant_image.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

ProductColorModel getColorDetails(String colorName) {
  final key = colorName.toLowerCase().trim();
  final match = electronicsColorsData.keys.firstWhere(
    (k) => key.contains(k),
    orElse: () => "default",
  );

  return electronicsColorsData[match] ??
      ProductColorModel(
        name: colorName,
        color: Colors.blueGrey,
        image: "https://via.placeholder.com/150",
      );
}

class ProductColorSelector extends StatelessWidget {
  final ProductModel product;
  final String selectedColor;
  final Function(String) onColorSelected;

  const ProductColorSelector({
    super.key,
    required this.product,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorsList = product.colors;
    if (colorsList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 14,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  boxShadow: [BoxShadow(color: AppColors.cyan.withValues(alpha: .5), blurRadius: 4)],
                ),
              ),
              Text(
                "CHOOSE_COLOR_VARIANT".toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  fontFamily: 'monospace',
                  color: AppColors.cyan,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colorsList.map((color) {
              final isSelected = selectedColor == color;
              final details = getColorDetails(color);
              final baseColor = details.color;

              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onColorSelected(color);
                },
                child: ColorVariantImage(
                  shadow: true,
                  isSelected: isSelected,
                  baseColor: baseColor,
                  details: details,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );

  }
}
