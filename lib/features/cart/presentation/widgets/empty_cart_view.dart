import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class EmptyCartView extends StatelessWidget {
  final VoidCallback onGoShopping;

  const EmptyCartView({super.key, required this.onGoShopping});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        // Background Grid for empty state
        const BackGrid(accentColor: AppColors.cyan),

        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glitchy/Neon Icon Container
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.1),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: AppColors.cyan.withValues(alpha: 0.8),
                    ),
                    // Geometric decorative lines
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 2,
                        color: AppColors.magenta,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      child: Container(
                        width: 2,
                        height: 40,
                        color: AppColors.magenta,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Monospace Title
                Text(
                  AppLocalizations.of(context)!.yourCartIsEmpty.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: AppColors.cyan,
                    shadows: [
                      Shadow(
                        color: AppColors.cyan.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Technical status text
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.magenta.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    "STATUS: [NO_ITEMS_DETECTED]",
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontFamily: 'monospace',
                      color: AppColors.magenta,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  AppLocalizations.of(context)!.addProductsToGetStarted,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 48),

                // Start Shopping Button
                GestureDetector(
                  onTap: onGoShopping,
                  child: Stack(
                    children: [
                      ClipPath(
                        clipper: CyberpunkCardClipper(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cyan.withValues(alpha: 0.1),
                            border: Border.all(color: AppColors.cyan, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.bolt,
                                color: AppColors.cyan,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.startShopping.toUpperCase(),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.cyan,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Floating aesthetic dots
                      Positioned(
                        top: 2,
                        left: 2,
                        child: Container(
                          width: 4,
                          height: 4,
                          color: AppColors.cyan,
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 4,
                          height: 4,
                          color: AppColors.cyan,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
