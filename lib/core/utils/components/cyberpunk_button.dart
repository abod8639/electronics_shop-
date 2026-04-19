import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';

class CyberpunkButton extends StatelessWidget {
  final double size;
  final Widget icon;
  final String? tooltip;
  final Function()? onTap;
  const CyberpunkButton({
    super.key,
    required this.size,
    required this.icon,
    required this.tooltip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF00F7).withValues(alpha: .3),
                blurRadius: 10,
                spreadRadius: -2,
              ),
            ],
          ),
          child: ClipPath(
            clipper: CyberpunkShapeClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  right: const BorderSide(color: Color(0xFFFF00F7), width: 3),
                  top: const BorderSide(color: Color(0xFFFF00F7), width: 1),
                ),
              ),
              child: IconButton(
                icon: icon,
                onPressed: onTap,
                tooltip: tooltip,
              ),
            ),
          ),
        ),
        BackGrid(accentColor: AppColors.cyan),
      ],
    );
  }
}
