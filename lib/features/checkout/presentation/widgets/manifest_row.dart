import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';

class ManifestRow extends StatelessWidget {
  final String label;
  final String value;
  const ManifestRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              fontSize: 12,
              color: AppColors.cyan,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Opacity(
              opacity: 0.2,
              child: Divider(color: AppColors.cyan, height: 1),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              fontSize: 12,
              color: AppColors.cyan,
            ),
          ),
        ],
      ),
    );
  }
}
