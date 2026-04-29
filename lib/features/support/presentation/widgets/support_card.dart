import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/constants/app_text_styles.dart';
import '../../domain/entities/support_entity.dart';

class SupportCard extends StatelessWidget {
  final SupportEntity entity;

  const SupportCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cyan.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.cyan.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.confirmation_number_outlined,
            color: AppColors.cyan,
            size: 20,
          ),
        ),
        title: Text(
          entity.name,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'TICKET_ID: ${entity.id}',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.grey,
            fontFamily: 'monospace',
            fontSize: 10,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
          ),
          child: Text(
            'ACTIVE',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.success,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
