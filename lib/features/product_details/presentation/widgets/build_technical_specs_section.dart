import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

Widget buildTechnicalSpecsSection(ProductModel product, bool isDark) {
  final dynamic technicalSpecs = product.technicalSpecifications;
  if (technicalSpecs == null ||
      technicalSpecs is! Map ||
      technicalSpecs.isEmpty) {
    return const SizedBox.shrink();
  }

  final specs = Map<String, dynamic>.from(technicalSpecs);

  return Builder(
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      final theme = Theme.of(context);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                // Icon(
                //   Icons.settings_suggest_outlined,
                //   size: 20,
                //   color: isDark ? AppColors.accent : AppColors.primary,
                // ),
                // const SizedBox(width: 8),
                Text(
                  l10n.technicalSpecifications,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDark
                  : AppColors.greyLight.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: specs.entries.indexed.map<Widget>((item) {
                final index = item.$1;
                final entry = item.$2;
                final isLast = index == specs.length - 1;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _getSpecIcon(entry.key, isDark),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 4,
                            child: Text(
                              entry.key,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 6,
                            child: Text(
                              entry.value.toString(),
                              textAlign: TextAlign.end,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        indent: 50,
                        endIndent: 16,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.05),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      );
    },
  );
}

Widget _getSpecIcon(String key, bool isDark) {
  final lowerKey = key.toLowerCase();
  IconData iconData = Icons.info_outline;
  Color iconColor = isDark ? Colors.grey[500]! : Colors.grey[400]!;

  if (lowerKey.contains('cpu') ||
      lowerKey.contains('processor') ||
      lowerKey.contains('chip')) {
    iconData = Icons.memory_rounded;
    iconColor = Colors.blue.withValues(alpha: .5);
  } else if (lowerKey.contains('ram') || lowerKey.contains('memory')) {
    iconData = Icons.speed_rounded;
    iconColor = Colors.orange.withValues(alpha: .5);
  } else if (lowerKey.contains('storage') ||
      lowerKey.contains('ssd') ||
      lowerKey.contains('hdd')) {
    iconData = Icons.storage_rounded;
    iconColor = Colors.amber.withValues(alpha: .5);
  } else if (lowerKey.contains('battery')) {
    iconData = Icons.battery_charging_full_rounded;
    iconColor = Colors.green.withValues(alpha: .5);
  } else if (lowerKey.contains('screen') || lowerKey.contains('display')) {
    iconData = Icons.screenshot_rounded;
    iconColor = Colors.purple.withValues(alpha: .5);
  } else if (lowerKey.contains('camera')) {
    iconData = Icons.camera_alt_rounded;
    iconColor = Colors.red.withValues(alpha: .5);
  } else if (lowerKey.contains('weight')) {
    iconData = Icons.monitor_weight_outlined;
    iconColor = Colors.teal.withValues(alpha: .5);
  } else if (lowerKey.contains('os') || lowerKey.contains('system')) {
    iconData = Icons.computer_rounded;
    iconColor = Colors.indigo.withValues(alpha: .5);
  }

  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: iconColor.withValues(alpha: 0.1),
      shape: BoxShape.circle,
    ),
    child: Icon(iconData, size: 18, color: iconColor),
  );
}
