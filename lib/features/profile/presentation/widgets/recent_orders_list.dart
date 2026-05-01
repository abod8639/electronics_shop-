import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/order/presentation/controllers/orders_controller.dart';
import 'package:electronics_shop/features/order/presentation/widgets/order_card.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/language_controller.dart';
import 'package:electronics_shop/routes/routes.dart';

class RecentOrdersList extends ConsumerWidget {
  const RecentOrdersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ordersState = ref.watch(ordersControllerProvider);
    final isDark = theme.brightness == Brightness.dark;
    final locale = ref.watch(languageControllerProvider);
    final isAr = locale.languageCode == 'ar';

    return ordersState.when(
      data: (orders) {
        final recentOrders = orders.take(3).toList();
        if (recentOrders.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme, isAr),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: recentOrders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final order = recentOrders[index];
                return OrderCard(
                  onTap: () =>
                      context.push(AppRoutes.orderDetails, extra: order),
                  order: order,
                  isDark: isDark,
                  isAr: isAr,
                );
              },
            ),
          ],
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator(color: AppColors.cyan)),
      error: (e, _) => Center(
        child: Text(
          'PROTOCOL_ERROR: $e',
          style: const TextStyle(
            fontFamily: 'monospace',
            color: AppColors.error,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isAr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: .5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                (isAr ? 'الطلبات الأخيرة' : 'RECENT_ORDERS').toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: 1.5,
                  fontSize: 14,
                  color: AppColors.cyan,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => context.push(AppRoutes.orderView),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.magenta,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (isAr ? 'عرض الكل' : 'BROWSE_ALL').toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(isAr ? Icons.chevron_left : Icons.chevron_right, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
