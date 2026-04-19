import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:electronics_shop/features/order/presentation/controllers/orders_controller.dart';
import 'package:electronics_shop/features/order/presentation/widgets/order_card.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/language_controller.dart';
import 'package:electronics_shop/routes/routes.dart';

class OrderView extends ConsumerWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(ordersControllerProvider);
    final ordersNotifier = ref.watch(ordersControllerProvider.notifier);

    // Fetch orders if not already fetched
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ordersState is! AsyncLoading && (ordersState.value?.length ?? 0) <= 3) {
        ordersNotifier.fetchAllOrders();
      }
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = ref.watch(languageControllerProvider);
    final isAr = locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[50],
      body: Stack(
        children: [
          const BackGrid(accentColor: AppColors.cyan,),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.cyan),
                    onPressed: () => context.pop(),
                  ),
                  title: Text(
                    isAr ? 'الطلبات' : 'ORDERS',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: isDark ? Colors.white : Colors.black,
                      shadows: [
                        Shadow(
                          color: AppColors.cyan.withValues(alpha: 0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  centerTitle: true,
                ),
                ordersState.when(
                  data: (orders) => orders.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'NO_DATA_FOUND',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                color: AppColors.magenta,
                              ),
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final order = orders[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: OrderCard(
                                    onTap: () => context.push(AppRoutes.orderDetails, extra: order),
                                    order: order,
                                    isDark: isDark,
                                    isAr: isAr,
                                  ),
                                );
                              },
                              childCount: orders.length,
                            ),
                          ),
                        ),
                  loading: () => const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.cyan),
                    ),
                  ),
                  error: (e, _) => SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'ERROR: ${e.toString().toUpperCase()}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: AppColors.magenta,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
