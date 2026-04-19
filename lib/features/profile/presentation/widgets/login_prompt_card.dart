import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/functions/app_guard.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/profile_controller.dart';
import 'package:electronics_shop/features/profile/presentation/widgets/account_settings_list.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:electronics_shop/routes/routes.dart';

class LoginPromptCard extends ConsumerWidget {
  const LoginPromptCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = Theme.of(context);
        final l10n = AppLocalizations.of(context)!;

        return Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: .1),
                blurRadius: 20,
                spreadRadius: -5,
                blurStyle: BlurStyle.outer,
              ),
            ],
          ),
          child: ClipPath(
            clipper: CyberpunkCardClipper(),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: .9),
                border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3), width: 0.5),
              ),
              child: Stack(
                children: [
                   BackGrid(accentColor: AppColors.cyan),
                  Column(
                    children: [
                      // Holographic Icon
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.cyan.withValues(alpha: 0.1),
                                  blurRadius: 30,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.lock_person_outlined,
                            size: 60,
                            color: AppColors.cyan,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Title
                      Text(
                        l10n.signInToYourAccount.toUpperCase(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          color: AppColors.cyan,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(color: AppColors.cyan.withValues(alpha: 0.5), blurRadius: 8),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      
                      // Status Label
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.magenta.withValues(alpha: 0.5)),
                        ),
                        child: const Text(
                          "ACCESS_LEVEL: [RESTRICTED]",
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: AppColors.magenta,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Text(
                        l10n.loginMessage,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontFamily: 'monospace',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      
                      // Login Buttons
                      _buildAuthButton(
                        context: context,
                        label: l10n.loginButtonLabel,
                        icon: Icons.login,
                        onTap: () => _handleLogin(context, ref),
                        isPrimary: true,
                      ),
                      const SizedBox(height: 16),
                      _buildAuthButton(
                        context: context,
                        label: l10n.signInWithGoogle,
                        icon: Icons.g_mobiledata_outlined,
                        onTap: () async {
                          AppGuard.runSafeInternet(ref, () async {
                            await ref.read(profileControllerProvider.notifier).signInWithGoogle();
                          });
                        },
                        isPrimary: false,
                      ),
                      
                      const SizedBox(height: 32),
                      const AccountSettingsList(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuthButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    final color = isPrimary ? AppColors.cyan : AppColors.magenta;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipPath(
            clipper: CyberpunkShapeClipper(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                border: Border.all(color: color, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 30),
                  const SizedBox(width: 12),
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: color,
                      letterSpacing: 1.5,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: Container(width: 4, height: 4, color: color),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context, WidgetRef ref) async {
    return AppGuard.runSafeInternet(ref, () async {
      ref.read(routerProvider).push(AppRoutes.auth);
    });
  }
}

