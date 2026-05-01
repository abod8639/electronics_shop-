import 'package:cached_network_image/cached_network_image.dart';
import 'package:electronics_shop/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:electronics_shop/features/order/data/models/order_model.dart';
import 'package:electronics_shop/features/order/presentation/widgets/order_status_timeline.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'MANIFEST #${order.id.toString().padLeft(6, '0')}',
          style: const TextStyle(
            color: AppColors.cyan,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.cyan),
      ),
      body: Stack(
        children: [
          const BackGrid(accentColor: AppColors.cyan),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Info Section
                _buildOrderManifestHeader(context),
                const SizedBox(height: 24),

                // Status Section
                _buildSectionHeader('LOGISTICS_STATUS'),
                ClipPath(
                  clipper: CyberpunkCardClipper(),
                  child: Stack(
                    children: [
                      BackGrid(accentColor: AppColors.cyan),
                      Container(
                        color: AppColors.black.withValues(alpha: 0.5),
                        padding: const EdgeInsets.all(20),
                        child: OrderStatusTimeline(order: order),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Items Section
                _buildSectionHeader('HARDWARE_ITEMS'),
                ...(order.items ?? []).map(
                  (item) => _buildOrderItem(context, item),
                ),

                const SizedBox(height: 32),
                _buildTotalFooter(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderManifestHeader(BuildContext context) {
    return ClipPath(
      clipper: CyberpunkCardClipper(),
      child: Container(
        color: AppColors.cyan.withValues(alpha: 0.1),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInfoRow('PROTOCOL_DATE', order.formattedDate),
            const Divider(color: Colors.white10, height: 24),
            _buildInfoRow('NODE_ID', 'CORE_SYS_${order.id}'),
            _buildInfoRow('CURRENCY', 'EGP_CREDITS'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4),
      child: Row(
        children: [
          Container(width: 4, height: 20, color: AppColors.magenta),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.magenta,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          Spacer(),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cyan.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.02),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            debugPrint('DEBUG_TARGET: ProductID(${item.productId})');
            if (item.productId != 0) {
              context.push(AppRoutes.productDetails, extra: item.productId);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'ERR_0x404: PRODUCT_DATA_NOT_FOUND',
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          splashColor: AppColors.cyan.withValues(alpha: 0.2),
          highlightColor: AppColors.cyan.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Product Image with Cyberpunk Frame
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.cyan.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: item.imageUrl ?? '',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.white10),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, color: Colors.white24),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          color: AppColors.cyan,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 1,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'UNIT_PRICE: ${item.price} Credits',
                        style: TextStyle(
                          color: AppColors.cyan.withValues(alpha: 0.7),
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildMiniBadge(
                            'QTY_${item.quantity}',
                            AppColors.cyan,
                          ),
                          if (item.selectedSize != null) ...[
                            const SizedBox(width: 8),
                            _buildMiniBadge(
                              'SIZE_${item.selectedSize}',
                              AppColors.magenta,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Subtotal
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'SUBTOTAL',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 8,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      '${item.subtotal}',
                      style: const TextStyle(
                        color: AppColors.magenta,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Text(
                      'CREDITS',
                      style: TextStyle(
                        color: AppColors.magenta,
                        fontSize: 8,
                        fontFamily: 'monospace',
                        letterSpacing: 1,
                      ),
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

  Widget _buildMiniBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  Widget _buildTotalFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.magenta.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.magenta.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TOTAL_ACQUISITION_VALUE',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            '${order.totalAmount} Credits',
            style: const TextStyle(
              color: AppColors.magenta,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
