import 'package:cached_network_image/cached_network_image.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/functions/cache_manager.dart';
import 'package:electronics_shop/core/utils/functions/show_address_form.dart';
import 'package:electronics_shop/features/cart/presentation/controllers/cart_controller.dart';
import 'package:electronics_shop/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/address_controller.dart';
import 'package:electronics_shop/features/checkout/presentation/widgets/build_payment_option.dart';

Step buildAddressStep(WidgetRef ref, String title) {
  final checkoutState = ref.watch(checkoutControllerProvider);
  final addresses = ref.watch(addressControllerProvider).value ?? [];

  return Step(
    title: Text(
      title,
      style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
    ),
    content: Column(
      children: [
        if (addresses.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '[ERROR]: NO_ADDRESS_FOUND. PLEASE_INITIALIZE_LOCATION_IN_PROFILE.',
              style: TextStyle(color: AppColors.magenta, fontFamily: 'monospace', fontSize: 12),
            ),
          )
        else
          Column(
            children: addresses.map((address) {
              final bool isSelected = checkoutState.selectedAddress?.id == address.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ClipPath(
                  clipper: CyberpunkCardClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.cyan.withValues(alpha: 0.05) : Colors.black12,
                      border: Border.all(
                        color: isSelected ? AppColors.cyan : AppColors.cyan.withValues(alpha: 0.2),
                        width: isSelected ? 1.5 : 0.5,
                      ),
                    ),
                    child: RadioListTile(
                      value: address,
                      groupValue: checkoutState.selectedAddress,
                      onChanged: (value) => ref
                          .read(checkoutControllerProvider.notifier)
                          .setAddress(value!),
                      title: Text(
                        (address.label ?? "UNLABELED_NODE").toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          color: isSelected ? AppColors.cyan : null,
                          letterSpacing: 1.2,
                        ),
                      ),
                      subtitle: Text(
                        address.fullAddress.toUpperCase(),
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                      ),
                      activeColor: AppColors.cyan,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => showAddressForm(ref.context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.magenta, width: 1),
              color: AppColors.magenta.withValues(alpha: 0.1),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: AppColors.magenta, size: 18),
                SizedBox(width: 8),
                Text(
                  'ADD_NEW_LOCATION_NODE',
                  style: TextStyle(
                    color: AppColors.magenta,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    isActive: checkoutState.currentStep >= 0,
    state: checkoutState.currentStep > 0 ? StepState.complete : StepState.editing,
  );
}

Step buildPaymentStep(WidgetRef ref, String title) {
  final checkoutState = ref.watch(checkoutControllerProvider);
  return Step(
    title: Text(
      title,
      style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
    ),
    content: Column(
      children: [
        buildPaymentOption(
          ref: ref,
          value: 'cash',
          title: 'CREDIT_LIQUID_CASH',
          icon: Icons.money,
        ),
        const SizedBox(height: 12),
        buildPaymentOption(
          ref: ref,
          value: 'card',
          title: 'SECURE_TRANS_CARD',
          icon: Icons.credit_card,
          subtitle: '[ENC_PENDING]',
          enabled: false,
        ),
      ],
    ),
    isActive: checkoutState.currentStep >= 1,
    state: checkoutState.currentStep > 1 ? StepState.complete : StepState.editing,
  );
}

Step buildReviewStep(WidgetRef ref, String title) {
  final checkoutState = ref.watch(checkoutControllerProvider);
  final cartState = ref.watch(cartControllerProvider);
  final cartNotifier = ref.watch(cartControllerProvider.notifier);

  return Step(
    title: Text(
      title,
      style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
    ),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: const BoxDecoration(
            color: AppColors.cyan,
          ),
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
                  border: Border(left: BorderSide(color: AppColors.cyan.withValues(alpha: 0.5), width: 2)),
                  color: AppColors.cyan.withValues(alpha: 0.03),
                ),
                child: ListTile(
                  dense: true,
                  leading: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                    ),
                    child: CachedNetworkImage(
                      cacheManager: CustomCacheManager.instance,
                      imageUrl: item.product.imageUrls.isNotEmpty
                          ? item.product.imageUrls.first.thumbnail
                          : '',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => const Icon(Icons.image, size: 20),
                    ),
                  ),
                  title: Text(
                    item.product.getLocalizedName(locale: 'en').toUpperCase(),
                    style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  subtitle: Text(
                    'UNIT_QTY: ${item.quantity} | PRICE: LE ${item.product.baseEffectivePrice}',
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
                  ),
                  trailing: Text(
                    'LE ${(item.product.baseEffectivePrice * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, color: AppColors.cyan),
                  ),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.cyan)),
          error: (e, _) => Text('[ERROR]: $e', style: const TextStyle(color: AppColors.magenta, fontFamily: 'monospace')),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace', color: AppColors.magenta),
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
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 12),
        ],
        const _ManifestRow(label: 'PAYMENT_PROTOCOL', value: 'AUTHORIZED'),
        Text(
          checkoutState.selectedPaymentMethod == 'cash'
              ? 'CREDIT_LIQUID_CASH'
              : 'SECURE_TRANS_CARD',
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 24),
        const Text(
          'PROTOCOL_NOTES:',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 12, color: AppColors.cyan),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: cartNotifier.notesController,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          decoration: InputDecoration(
            border: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cyan)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.cyan.withValues(alpha: 0.3))),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cyan)),
            hintText: 'INPUT_EXTRA_NOTES_HERE...',
            hintStyle: TextStyle(color: Colors.white24, fontFamily: 'monospace', fontSize: 11),
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 12, color: AppColors.cyan),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Opacity(opacity: 0.2, child: Divider(color: AppColors.cyan, height: 1))),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 12, color: AppColors.cyan),
          ),
        ],
      ),
    );
  }
}

