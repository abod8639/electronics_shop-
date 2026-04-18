import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class HeaderWithIconandTitle extends StatelessWidget {
  final Widget? icon;
  final String title;
  final Color? color;
  final double fontSize;
  final EdgeInsets? padding;

  const HeaderWithIconandTitle({
    super.key,
    this.icon,
    required this.title,
    this.color,
    this.fontSize = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = color ?? AppColors.cyan;

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(
            color: accentColor.withValues(alpha: .2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: .1),
                border: Border.all(color: accentColor.withValues(alpha: 0.3)),
              ),
              child: IconTheme(
                data: IconThemeData(color: accentColor, size: 24),
                child: icon!,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              letterSpacing: 1.2,
              color: isDark ? accentColor : Colors.black87,
              shadows: [
                if (isDark)
                  Shadow(
                    color: accentColor.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
