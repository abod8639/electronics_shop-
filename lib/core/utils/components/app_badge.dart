import 'package:flutter/material.dart';

/// A shared, reusable badge/chip widget with a colored border and background.
///
/// Replaces the duplicate implementations in:
/// - `order/widgets/build_status_badge.dart`
/// - `product_details/widgets/build_product_badges.dart` (_buildBadge)
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    required this.color,
    this.backgroundAlpha = 0.1,
    this.borderAlpha = 0.3,
    this.fontSize = 10.0,
    this.letterSpacing = 0.3,
  });

  final String label;
  final Color color;

  /// The opacity of the badge background fill (0.0 – 1.0).
  final double backgroundAlpha;

  /// The opacity of the badge border (0.0 – 1.0).
  final double borderAlpha;

  final double fontSize;
  final double letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: backgroundAlpha),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: borderAlpha)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}
