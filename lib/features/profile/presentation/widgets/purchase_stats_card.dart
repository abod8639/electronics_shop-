import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/profile_controller.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class PurchaseStatsCard extends ConsumerWidget {
  const PurchaseStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileNotifier = ref.watch(profileControllerProvider.notifier);
    final intl10n = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: .1),
            blurRadius: 15,
            spreadRadius: -2,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.95),
          border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2), width: 0.5),
        ),
        child: Stack(
          children: [
            // BackGrid(accentColor: AppColors.cyan),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  intl10n.totalSpent.toUpperCase(),
                  'EG£ ${profileNotifier.totalSpent.toStringAsFixed(0)}',
                  Icons.account_balance_wallet_outlined,
                  AppColors.cyan,
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: AppColors.cyan.withValues(alpha: 0.2),
                ),
                _buildStatItem(
                  intl10n.completed.toUpperCase(),
                  profileNotifier.deliveredOrders.toString().padLeft(2, '0'),
                  Icons.verified_outlined,
                  AppColors.cyan,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'monospace',
                letterSpacing: -0.5,
                shadows: [
                  Shadow(color: color.withValues(alpha: 0.4), blurRadius: 8),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w900,
            color: color.withValues(alpha: 0.6),
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}

