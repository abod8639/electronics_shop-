import 'package:flutter/material.dart';

/// A shared, reusable info row that displays a label and a value.
///
/// Supports an optional [icon] prefix (replaces build_info_item.dart).
/// Without icon it acts as a spaceBetween label-value row (replaces build_row_info.dart).
///
/// Replaces:
/// - `order/widgets/build_info_item.dart`  (with icon)
/// - `order/widgets/build_row_info.dart`   (without icon)
class AppInfoRow extends StatelessWidget {
  const AppInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;

  /// When provided, shows the icon to the left of label+value column.
  /// When null, displays label and value as a spaceBetween row.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (icon != null) {
      return _buildWithIcon(theme);
    }
    return _buildSpaceBetween(theme);
  }

  /// Icon | [label (small, grey)]
  ///      | [value (bold)]
  Widget _buildWithIcon(ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// [label]  ............  [value]
  Widget _buildSpaceBetween(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
