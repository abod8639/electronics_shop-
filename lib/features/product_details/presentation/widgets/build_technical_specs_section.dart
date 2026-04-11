import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

Widget buildTechnicalSpecsSection(ProductModel product, bool isDark) {
  final specs = product.technicalSpecifications;
  if (specs == null || specs.isEmpty) return const SizedBox.shrink();

  return Builder(
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.technicalSpecifications,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDark
                  : AppColors.greyLight.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: specs.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 6,
                        child: Text(
                          entry.value.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppColors.white : AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    },
  );
}
