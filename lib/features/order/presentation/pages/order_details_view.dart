import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:electronics_shop/features/order/data/models/order_model.dart';
import 'package:electronics_shop/features/order/presentation/widgets/order_status_timeline.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                  child: Container(
                    color: Colors.white.withOpacity(0.05),
                    padding: const EdgeInsets.all(20),
                    child: OrderStatusTimeline(order: order),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Items Section
                _buildSectionHeader('HARDWARE_ITEMS'),
                ...(order.items ?? []).map((item) => _buildOrderItem(context, item)),
                
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
        color: AppColors.cyan.withOpacity(0.1),
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
          Container(
            width: 4,
            height: 20,
            color: AppColors.magenta,
          ),
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
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      
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
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.cyan, width: 2)),
        color: Colors.white.withOpacity(0.02),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
          ),
          child: CachedNetworkImage(
            imageUrl: item.imageUrl ?? '',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.white10),
            errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white24),
          ),
        ),
        title: Text(
          item.productName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          'QUANTITY: ${item.quantity}',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontFamily: 'monospace',
          ),
        ),
        trailing: Text(
          '${item.price} Credits',
          style: const TextStyle(
            color: AppColors.cyan,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  Widget _buildTotalFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.magenta.withOpacity(0.05),
        border: Border.all(color: AppColors.magenta.withOpacity(0.2)),
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
