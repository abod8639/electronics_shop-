import 'package:flutter/material.dart';

/// A shared card/section container with rounded corners and an adaptive shadow.
///
/// Automatically adapts its background and shadow based on [Brightness].
/// Replaces the inline Container decoration in:
/// - `order/widgets/build_section.dart`
/// - Inline Container decoration in `order/widgets/order_card.dart`
class AppCardSection extends StatelessWidget {
  const AppCardSection({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16.0,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  /// If provided, wraps the card in an [InkWell] with the given callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? const Color(0xFF131313) // AppColors.surfaceDark
        : Colors.white;
    final shadowColor = Colors.black.withValues(alpha: isDark ? 0.2 : 0.05);

    final container = Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: onTap,
                child: Padding(padding: padding, child: child),
              ),
            )
          : Padding(padding: padding, child: child),
    );

    return container;
  }
}
