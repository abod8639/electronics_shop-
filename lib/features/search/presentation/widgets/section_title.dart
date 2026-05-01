import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class SectionTitle extends StatelessWidget {
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 10.0;
  final String title;
  final VoidCallback? onSeeAllPressed;
  final String? buttonTitle;

  const SectionTitle({
    super.key,
    required this.title,
    this.onSeeAllPressed,
    this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cyan = AppColors.cyan;
    final magenta = AppColors.magenta;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: cyan,
                    boxShadow: [
                      BoxShadow(
                        color: cyan.withValues(alpha: .5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Text(
                    title.toUpperCase(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontFamily: 'monospace',
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onSeeAllPressed != null || buttonTitle != null)
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: onSeeAllPressed,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (buttonTitle ?? AppLocalizations.of(context)!.seeAll)
                        .toUpperCase(),
                    style: TextStyle(
                      color: magenta,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 1,
                    color: magenta.withValues(alpha: .5),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
