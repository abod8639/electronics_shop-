import 'package:flutter/material.dart';

class GridBackground extends StatelessWidget {
  final Widget child;
  const GridBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Dark background base
        Positioned.fill(
          child: Container(
            color: const Color(0xFF0A0A0A),
          ),
        ),
        
        // 2. Neon grid
        Positioned.fill(
          child: CustomPaint(
            painter: _GridPainter(
              color: const Color(0xFFBF00FF).withOpacity(0.08),
              step: 35.0,
            ),
          ),
        ),

        // 3. Radial depth glow
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  const Color(0xFFBF00FF).withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        
        // 4. Content
        child,
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  final double step;

  _GridPainter({required this.color, required this.step});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    // Vertical lines
    for (double i = 0; i <= size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Horizontal lines
    for (double i = 0; i <= size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
