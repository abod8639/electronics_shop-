import 'package:flutter/material.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class SectionTitle extends StatelessWidget {
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 10.0;
  final String title;
  final VoidCallback? onSeeAllPressed;
  final String? buttonTitle;

  const SectionTitle({super.key, required this.title, this.onSeeAllPressed, this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        left: _horizontalPadding,
        right: _horizontalPadding,
        bottom: _verticalPadding,
        top: _verticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              // AppLocalizations.of(context)!.mostPopularOffers,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          if (onSeeAllPressed != null || buttonTitle != null)
            TextButton(
              onPressed: onSeeAllPressed,
              child: Text(buttonTitle ?? AppLocalizations.of(context)!.seeAll),
            ),

        ],
      ),
    );
  }
}
