import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
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

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: .05),
            blurRadius: 10,
            spreadRadius: -2,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkCardClipper(),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.9),
              border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2), width: 0.5),
            ),
            child: Stack(
              children: [
                BackGrid(accentColor: AppColors.cyan),
                Column(
                  children: [
                    // Top row: order number + status
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.cyan),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.qr_code_2,
                            size: 14,
                            color: AppColors.cyan,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (isAr ? 'ORD_#' : 'ORD_#') + order.id.toString().substring(0, 8).toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                  color: AppColors.cyan,
                                ),
                              ),
                              Text(
                                DateFormat('yy.MM.dd // HH:mm').format(order.orderDate!),
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                  fontFamily: 'monospace',
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            border: Border.all(color: statusColor, width: 0.5),
                          ),
                          child: Text(
                            (statusData['text'] as String).toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, thickness: 0.3, color: AppColors.cyan),
                    ),
                    // Bottom row: image + product name + price
                    Row(
                      children: [
                        ClipPath(
                          clipper: CyberpunkShapeClipper(),
                          child: AppNetworkImage(
                            imageUrl: order.items?.first.imageUrl,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.items?.first.productName ?? '',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              if ((order.items?.length ?? 0) > 1)
                                Text(
                                  isAr
                                      ? '+${order.items!.length - 1} وحدات إضافية'
                                      : '+${order.items!.length - 1} MORE_ENTITIES',
                                  style: const TextStyle(
                                    color: AppColors.magenta,
                                    fontFamily: 'monospace',
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.magenta,
                                fontFamily: 'monospace',
                                fontSize: 16,
                                shadows: [
                                  Shadow(color: AppColors.magenta, blurRadius: 4),
                                ],
                              ),
                            ),
                            const Text(
                              "EGP",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontFamily: 'monospace',
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusData(String status, bool isAr) {
    switch (status.toLowerCase()) {
      case 'pending':
        return {
          'text': isAr ? 'قيد الانتظار' : 'Pending',
          'color': AppColors.cyan,
        };
      case 'processing':
        return {
          'text': isAr ? 'يتم التجهيز' : 'Processing',
          'color': AppColors.cyan,
        };
      case 'shipped':
        return {'text': isAr ? 'تم الشحن' : 'Shipped', 'color': Colors.blueAccent};
      case 'delivered':
        return {
          'text': isAr ? 'تم التوصيل' : 'Delivered',
          'color': Colors.greenAccent,
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

