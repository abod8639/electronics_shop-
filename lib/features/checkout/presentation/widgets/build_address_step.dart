
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:electronics_shop/core/utils/functions/show_address_form.dart';
import 'package:electronics_shop/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/address_controller.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter_riverpod/flutter_riverpod.dart';

Step buildAddressStep(WidgetRef ref, String title) {
  final checkoutState = ref.watch(checkoutControllerProvider);
  final addresses =
      ref.watch(addressControllerProvider).valueOrNull?.addresses ?? [];

  return Step(
    title: Text(
      title,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Column(
      children: [
        if (addresses.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '[ERROR]: NO_ADDRESS_FOUND. PLEASE_INITIALIZE_LOCATION_IN_PROFILE.',
              style: TextStyle(
                color: AppColors.magenta,
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          )
        else
          Column(
            children: addresses.map((address) {
              final bool isSelected =
                  checkoutState.selectedAddress?.id == address.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ClipPath(
                  clipper: CyberpunkCardClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.cyan.withValues(alpha: 0.05)
                          : Colors.black12,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.cyan
                            : AppColors.cyan.withValues(alpha: 0.2),
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
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                        ),
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
    state: checkoutState.currentStep > 0
        ? StepState.complete
        : StepState.editing,
  );
}
