
import 'package:electronics_shop/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:electronics_shop/features/checkout/presentation/widgets/build_payment_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Step buildPaymentStep(WidgetRef ref, String title) {
  final checkoutState = ref.watch(checkoutControllerProvider);
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
    state: checkoutState.currentStep > 1
        ? StepState.complete
        : StepState.editing,
  );
}
