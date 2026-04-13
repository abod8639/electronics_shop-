import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/app_badge.dart';
import 'package:electronics_shop/core/utils/components/app_card_section.dart';
import 'package:electronics_shop/core/utils/components/app_network_image.dart';
import 'package:electronics_shop/features/order/data/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;
  final bool isAr;
  final Function()? onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.isDark,
    required this.isAr,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusData = _getStatusData(order.status, isAr);
    final statusColor = statusData['color'] as Color;

    return AppCardSection(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Column(
        children: [
          // Top row: order number + status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr
                          ? 'طلب #${order.id.toString().substring(0, 6)}'
                          : 'Order #${order.id.toString().substring(0, 6)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy • hh:mm a').format(
                        order.orderDate!,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              AppBadge(
                label: statusData['text'] as String,
                color: statusColor,
                backgroundAlpha: 0.1,
                borderAlpha: 0.2,
                fontSize: 10,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 0.5),
          ),
          // Bottom row: image + product name + price
          Row(
            children: [
              AppNetworkImage(
                imageUrl: order.items?.first.imageUrl,
                width: 50,
                height: 50,
                borderRadius: 12,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.items?.first.productName ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if ((order.items?.length ?? 0) > 1)
                      Text(
                        isAr
                            ? '+${order.items!.length - 1} منتجات أخرى'
                            : '+${order.items!.length - 1} items more',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.totalAmount.toStringAsFixed(2),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    isAr ? 'ج.م' : 'EGP',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusData(String status, bool isAr) {
    switch (status.toLowerCase()) {
      case 'pending':
        return {
          'text': isAr ? 'قيد الانتظار' : 'Pending',
          'color': AppColors.warning,
        };
      case 'processing':
        return {
          'text': isAr ? 'يتم التجهيز' : 'Processing',
          'color': AppColors.primary,
        };
      case 'shipped':
        return {'text': isAr ? 'تم الشحن' : 'Shipped', 'color': Colors.blue};
      case 'delivered':
        return {
          'text': isAr ? 'تم التوصيل' : 'Delivered',
          'color': AppColors.success,
        };
      case 'cancelled':
        return {
          'text': isAr ? 'ملغي' : 'Cancelled',
          'color': AppColors.error,
        };
      default:
        return {'text': status.toUpperCase(), 'color': AppColors.greyDark};
    }
  }
}
