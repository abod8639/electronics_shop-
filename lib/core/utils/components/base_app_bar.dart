import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

AppBar baseAppBar(BuildContext context, String title) {
  final theme = Theme.of(context);
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(
      title.toUpperCase(),
      style: theme.textTheme.titleLarge?.copyWith(
        fontFamily: 'monospace',
        fontWeight: FontWeight.bold,
        color: AppColors.cyan,
        letterSpacing: 2,
        shadows: [
          Shadow(color: AppColors.cyan.withValues(alpha: 0.5), blurRadius: 10),
        ],
      ),
    ),
    centerTitle: true,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        color: AppColors.cyan.withValues(alpha: 0.3),
        height: 1.0,
      ),
    ),
  );
}

