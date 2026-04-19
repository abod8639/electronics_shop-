import 'dart:math' as math;
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:electronics_shop/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderSuccessView extends StatefulWidget {
  const OrderSuccessView({super.key});

  @override
  State<OrderSuccessView> createState() => _OrderSuccessViewState();
}

class _OrderSuccessViewState extends State<OrderSuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          const BackGrid(accentColor: AppColors.cyan),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: Column(
                  mainAxisAlignment: MainToCenter,
                  children: [
                    // Glitchy Success Icon
                    _buildAnimatedIcon(),
                    const SizedBox(height: 32),
                    
                    // Main Title
                    Text(
                      'TRANSACTION_SECURED',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: AppColors.cyan.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ORDER_ID: #${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: AppColors.magenta,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Cyberpunk Manifest Card
                    ClipPath(
                      clipper: CyberpunkCardClipper(),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.cyan.withValues(alpha: 0.5),
                              AppColors.magenta.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                        child: ClipPath(
                          clipper: CyberpunkCardClipper(),
                          child: Container(
                            color: isDark ? Colors.black.withValues(alpha: 0.9) : Colors.white,
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                _buildDetailRow('STATUS', 'SUCCESS_VERIFIED', AppColors.cyan),
                                const Divider(color: Colors.white10),
                                _buildDetailRow('TIMELINE', 'INSTANT_PROCESSING', Colors.white70),
                                _buildDetailRow('NETWORK', 'SECURE_NODE_09', Colors.white70),
                                const SizedBox(height: 16),
                                Text(
                                  'Your order has been broadcast to our logistics centers. Deployment of hardware is imminent.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    color: isDark ? Colors.white54 : Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Actions
                    _buildCyberButton(
                      context,
                      label: 'TRACK TRANSMISSION',
                      color: AppColors.cyan,
                      onPressed: () => context.pushReplacement(AppRoutes.orderDetails),
                    ),
                    const SizedBox(height: 16),
                    _buildCyberButton(
                      context,
                      label: 'RETURN TO STORE',
                      color: AppColors.magenta,
                      onPressed: () => context.go(AppRoutes.home),
                      isOutlined: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double glitch = math.sin(_controller.value * 20) * 2;
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: Offset(glitch, 0),
              child: Icon(
                Icons.check_circle_outline,
                size: 100,
                color: AppColors.magenta.withValues(alpha: 0.3),
              ),
            ),
            Transform.translate(
              offset: Offset(-glitch, 0),
              child: Icon(
                Icons.check_circle_outline,
                size: 100,
                color: AppColors.cyan.withValues(alpha: 0.3),
              ),
            ),
            const Icon(
              Icons.check_circle,
              size: 100,
              color: AppColors.cyan,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCyberButton(BuildContext context, {
    required String label, 
    required Color color, 
    required VoidCallback onPressed,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: GestureDetector(
        onTap: onPressed,
        child: CustomPaint(
          painter: CyberButtonPainter(color: color, isOutlined: isOutlined),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Reuse the constant for vertical alignment to avoid the non-existent MainToCenter
const MainAxisAlignment MainToCenter = MainAxisAlignment.center;

class CyberButtonPainter extends CustomPainter {
  final Color color;
  final bool isOutlined;
  CyberButtonPainter({required this.color, this.isOutlined = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = isOutlined ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeWidth = isOutlined ? 2 : 0;

    final path = Path();
    const double cut = 15.0;
    path.moveTo(0, cut);
    path.lineTo(cut, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cut);
    path.lineTo(size.width - cut, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    if (!isOutlined) {
        // Shine line
        final shinePaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        
        final shinePath = Path();
        shinePath.moveTo(cut + 5, 5);
        shinePath.lineTo(size.width - 5, 5);
        canvas.drawPath(shinePath, shinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
