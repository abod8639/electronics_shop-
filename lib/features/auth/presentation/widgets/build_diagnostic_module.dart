import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

Widget buildDiagnosticModule(AppLocalizations l10n) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: AppColors.magenta),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "IDENTITY_VERIFICATION_REQUIRED",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: AppColors.magenta.withValues(alpha: 0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "STATUS: [PENDING_INPUT]",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: AppColors.magenta.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }