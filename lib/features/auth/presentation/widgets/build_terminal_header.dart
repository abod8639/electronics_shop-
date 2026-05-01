import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

Widget buildTerminalHeader(AppLocalizations l10n) {
    return Column(
      children: [
        const Icon(Icons.security_rounded, color: AppColors.cyan, size: 64),
        const SizedBox(height: 16),
        Text(
          "SECURE_AUTH_PROTOCOL",
          style: TextStyle(
            fontFamily: 'monospace',
            color: AppColors.cyan.withValues(alpha: 0.5),
            fontSize: 10,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.welcomeBack.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: AppColors.cyan,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
