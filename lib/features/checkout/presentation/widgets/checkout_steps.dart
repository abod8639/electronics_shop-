import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/functions/cache_manager.dart';
import 'package:electronics_shop/features/cart/presentation/controllers/cart_controller.dart';
import 'package:electronics_shop/features/checkout/presentation/controllers/checkout_controller.dart';

Step buildReviewStep(WidgetRef ref, String title) {
  final checkoutState = ref.watch(checkoutControllerProvider);
  final cartState = ref.watch(cartControllerProvider);
  final cartNotifier = ref.watch(cartControllerProvider.notifier);

  return Step(
    title: Text(
      title,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: const BoxDecoration(color: AppColors.cyan),
          child: const Text(
            'TRANSACTION_MANIFEST',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 16),
        cartState.when(
          data: (items) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: AppColors.cyan.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  color: AppColors.cyan.withValues(alpha: 0.03),
                ),
                child: ListTile(
                  dense: true,
                  leading: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.cyan.withValues(alpha: 0.3),
                      ),
                    ),
                    child: CachedNetworkImage(
                      cacheManager: CustomCacheManager.instance,
                      imageUrl: item.product.imageUrls.isNotEmpty
                          ? item.product.imageUrls.first.thumbnail
                          : '',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) =>
                          const Icon(Icons.image, size: 20),
                    ),
                  ),
                  title: Text(
                    item.product.getLocalizedName(locale: 'en').toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    'UNIT_QTY: ${item.quantity} | PRICE: LE ${item.product.baseEffectivePrice}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                    ),
                  ),
                  trailing: Text(
                    'LE ${(item.product.baseEffectivePrice * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: AppColors.cyan,
                    ),
                  ),
                ),
              );
            },
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.cyan),
          ),
          error: (e, _) => Text(
            '[ERROR]: $e',
            style: const TextStyle(
              color: AppColors.magenta,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.magenta.withValues(alpha: 0.5)),
            color: AppColors.magenta.withValues(alpha: 0.05),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL_CREDITS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: AppColors.magenta,
                ),
              ),
              Text(
                'LE ${cartNotifier.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: AppColors.magenta,
                  fontFamily: 'monospace',
                  shadows: [Shadow(color: AppColors.magenta, blurRadius: 8)],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (checkoutState.selectedAddress != null) ...[
          const _ManifestRow(label: 'DESTINATION_NODE', value: 'VERIFIED'),
          Text(
            checkoutState.selectedAddress!.fullAddress.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
        ],
        const _ManifestRow(label: 'PAYMENT_PROTOCOL', value: 'AUTHORIZED'),
        Text(
          checkoutState.selectedPaymentMethod == 'cash'
              ? 'CREDIT_LIQUID_CASH'
              : 'SECURE_TRANS_CARD',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'PROTOCOL_NOTES:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            fontSize: 12,
            color: AppColors.cyan,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: cartNotifier.notesController,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.cyan),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.cyan.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.cyan),
            ),
            hintText: 'INPUT_EXTRA_NOTES_HERE...',
            hintStyle: TextStyle(
              color: Colors.white24,
              fontFamily: 'monospace',
              fontSize: 11,
            ),
            fillColor: Colors.black26,
            filled: true,
          ),
        ),
      ],
    ),
    isActive: checkoutState.currentStep >= 2,
    state: StepState.editing,
  );
}

class _ManifestRow extends StatelessWidget {
  final String label;
  final String value;
  const _ManifestRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              fontSize: 12,
              color: AppColors.cyan,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Opacity(
              opacity: 0.2,
              child: Divider(color: AppColors.cyan, height: 1),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              fontSize: 12,
              color: AppColors.cyan,
            ),
          ),
        ],
      ),
    );
  }
}
