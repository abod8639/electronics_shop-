import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/app_card_section.dart';
import 'package:electronics_shop/core/utils/components/app_network_image.dart';
import 'package:electronics_shop/features/order/data/models/order_model.dart';

Widget buildOrderItem(OrderItemModel item, bool isDark, bool isAr) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return AppCardSection(
        padding: const EdgeInsets.all(12),
        borderRadius: 12,
        child: Row(
          children: [
            AppNetworkImage(
              imageUrl: item.imageUrl,
              width: 60,
              height: 60,
              borderRadius: 10,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.selectedFlavor != null || item.selectedSize != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        [
                          item.selectedFlavor,
                          item.selectedSize,
                        ].where((e) => e != null).join(' | '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.quantity} x ${item.unitPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              '${item.subtotal.toStringAsFixed(2)} ${isAr ? "ج.م" : "EGP"}',
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    },
  );
}
