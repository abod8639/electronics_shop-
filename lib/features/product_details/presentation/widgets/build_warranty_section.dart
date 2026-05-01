import 'package:electronics_shop/features/product_details/presentation/widgets/expandable_description_card.dart';
import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

Widget buildWarrantySection(ProductModel product, bool isDark) {
  final warranty = product.warrantyInfo;
  if (warranty == null || warranty.isEmpty) return const SizedBox.shrink();

  return Builder(
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return ExpandableDescriptionCard(
        icon: Icon(Icons.verified_user_outlined),
        title: l10n.warrantyInfo.toUpperCase(),
        child: Row(
          children: [
            const SizedBox(width: 6),
            Icon(Icons.verified_user_outlined, size: 25, color: AppColors.cyan),
            // const SizedBox(width: 12),
            Spacer(),
            Text(
              warranty,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.white : AppColors.black,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    },
  );
}
