
import 'package:flutter/material.dart';

class BackGrid extends StatelessWidget {
  const BackGrid({
    super.key,
    required this.accentColor,
  });

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.04,
        child: GridPaper(
          color: accentColor,
          divisions: 1,
          subdivisions: 1,
          interval: 20,
        ),
      ),
    );
  }
}
