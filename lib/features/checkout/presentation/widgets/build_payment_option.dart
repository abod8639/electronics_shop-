import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/checkout/presentation/controllers/checkout_controller.dart';

Widget buildPaymentOption({
  required WidgetRef ref,
  required String value,
  required String title,
  required IconData icon,
  String? subtitle,
  bool enabled = true,
}) {
  final checkoutState = ref.watch(checkoutControllerProvider);
  final isSelected = checkoutState.selectedPaymentMethod == value;

  return ClipPath(
    clipper: CyberpunkCardClipper(),
    child: Container(
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.cyan.withValues(alpha: .05)
            : Colors.black12,
        border: Border.all(
          color: isSelected
              ? AppColors.cyan
              : AppColors.cyan.withValues(alpha: enabled ? 0.2 : 0.05),
          width: isSelected ? 1.5 : 0.5,
        ),
      ),
      child: RadioListTile(
        value: value,
        groupValue: checkoutState.selectedPaymentMethod,
        onChanged: enabled
            ? (val) => ref
                  .read(checkoutControllerProvider.notifier)
                  .setPaymentMethod(val.toString())
            : null,
        title: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            letterSpacing: 1.2,
            color: enabled
                ? (isSelected ? AppColors.cyan : null)
                : Colors.grey.withValues(alpha: 0.5),
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: enabled ? null : Colors.grey.withValues(alpha: 0.3),
                ),
              )
            : null,
        secondary: Icon(
          icon,
          color: enabled
              ? (isSelected
                    ? AppColors.cyan
                    : AppColors.cyan.withValues(alpha: 0.5))
              : Colors.grey.withValues(alpha: 0.2),
        ),
        activeColor: AppColors.cyan,
      ),
    ),
  );
}
