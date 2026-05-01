import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

Widget buildDivider(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.cyan.withValues(alpha: 0.1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            l10n.or.toUpperCase(),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: AppColors.cyan.withValues(alpha: 0.3),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.cyan.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }