import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/profile_controller.dart';
import 'package:electronics_shop/routes/routes.dart';

class QuickActionsRow extends ConsumerWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileNotifier = ref.watch(profileControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              context,
              icon: Icons.inventory_2_outlined,
              label: 'ORDERS',
              value: profileNotifier.totalOrders.toString().padLeft(2, '0'),
              color: AppColors.cyan,
              onTap: () {},
            ),
          ),
          // const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              context,
              icon: Icons.favorite_outline,
              label: 'WISHLIST',
              value: profileNotifier.wishlistCount.toString().padLeft(2, '0'),
              color: AppColors.magenta,
              onTap: () => context.push(AppRoutes.wishlist),
            ),
          ),
          // const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              context,
              icon: Icons.terminal_outlined,
              label: 'ADDR_LOG',
              value: profileNotifier.addresses.length.toString().padLeft(2, '0'),
              color: AppColors.cyan,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipPath(
            clipper: CyberpunkCardClipper(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.9),
                border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
              ),
              child: Stack(
                children: [
                  BackGrid(accentColor: color),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: color, size: 24),
                      const SizedBox(height: 12),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontFamily: 'monospace',
                          height: 1,
                          shadows: [
                            Shadow(color: color.withValues(alpha: 0.4), blurRadius: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w900,
                          color: color.withValues(alpha: 0.7),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Positioned(
          //   right: 4,
          //   top: 4,
          //   child: Container(width: 3, height: 3, color: color),
          // ),
        ],
      ),
    );
  }
}

