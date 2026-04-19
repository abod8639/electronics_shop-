import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/routes/routes.dart';
import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const BackGrid(accentColor: AppColors.cyan,),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header Status
                    _buildStatusHeader(context),
                    const SizedBox(height: 32),
                    
                    // Transaction Manifest Card
                    ClipPath(
                      clipper: CyberpunkCardClipper(),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.success.withOpacity(0.5),
                              AppColors.primary.withOpacity(0.5),
                            ],
                          ),
                        ),
                        child: ClipPath(
                          clipper: CyberpunkCardClipper(),
                          child: Container(
                            color: Colors.black.withOpacity(0.9),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('SYSTEM_STATUS', 'OPERATIONAL', AppColors.success),
                                const Divider(color: Colors.white24, height: 24),
                                _buildInfoRow('TRANSACTION', 'VERIFIED', AppColors.primary),
                                _buildInfoRow('SECURITY', 'ENCRYPTED', Colors.cyan),
                                const SizedBox(height: 16),
                                Text(
                                  'Thank you for your purchase. Your hardware acquisition protocol has been initiated. Tracking node will be assigned shortly.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontFamily: 'monospace',
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _buildManifestSeal(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // Action Button
                    _buildContinueButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.qr_code_scanner,
            size: 80,
            color: AppColors.cyan,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'PROTOCOL: SUCCESS',
          style: TextStyle(
            color: AppColors.cyan,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            fontFamily: 'monospace',
          ),
        ),
        Text(
          'ORDER_MANIFEST_ACCEPTED',
          style: TextStyle(
            color: AppColors.success.withOpacity(0.8),
            fontSize: 12,
            letterSpacing: 2,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManifestSeal() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'SECURE_HASH_0X7F4B',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white30,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return ClipPath(
      clipper: CyberpunkShapeClipper(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: 
            // [AppColors.cyan, AppColors.magenta],
            [AppColors.cyan, AppColors.magenta],
          ),
        ),
        child: ElevatedButton(
          onPressed: () => context.go(AppRoutes.main),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: 48,
              vertical: 20,
            ),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: const Text(
            'RETURN TO TERMINAL',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ),
    );
  }
}
