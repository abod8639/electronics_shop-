import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/profile_controller.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(profileControllerProvider.notifier).currentUser;
    final isDark = theme.brightness == Brightness.dark;

    if (user == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: .1),
            blurRadius: 20,
            spreadRadius: -2,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkCardClipper(),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.9),
            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3), width: 0.5),
          ),
          child: Stack(
            children: [
              BackGrid(accentColor: AppColors.cyan),
              Row(
                children: [
                   // Avatar with neon glow
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.cyan, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cyan.withValues(alpha: 0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                              ? Image.network(user.photoUrl!, fit: BoxFit.cover)
                              : Container(
                                  color: AppColors.cyan.withValues(alpha: 0.1),
                                  child: const Icon(Icons.person, color: AppColors.cyan, size: 40),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.colorScheme.surface, width: 2),
                            boxShadow: [
                              BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.5), blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "OPERATOR_IDENTITY",
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            letterSpacing: 1,
                            color: AppColors.cyan.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.name.toUpperCase(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            color: AppColors.cyan,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.magenta.withValues(alpha: 0.8),
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Technical badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.5)),
                          ),
                          child: const Text(
                            "STATUS: VERIFIED // SECURE_AUTH",
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8,
                              color: AppColors.cyan,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

