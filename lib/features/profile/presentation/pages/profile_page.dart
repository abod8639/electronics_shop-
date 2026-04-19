import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/auth/presentation/controllers/auth_controller.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/profile_controller.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:electronics_shop/features/profile/presentation/widgets/profile_header.dart';
import 'package:electronics_shop/features/profile/presentation/widgets/quick_actions_row.dart';
import 'package:electronics_shop/features/profile/presentation/widgets/purchase_stats_card.dart';
import 'package:electronics_shop/features/profile/presentation/widgets/recent_orders_list.dart';
import 'package:electronics_shop/features/profile/presentation/widgets/saved_addresses_list.dart';
import 'package:electronics_shop/features/profile/presentation/widgets/account_settings_list.dart';
import 'package:electronics_shop/features/profile/presentation/widgets/login_prompt_card.dart';
import 'package:electronics_shop/routes/routes.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final currentUser = authState.value;
    final isLoading = authState.isLoading;
    final orders = ref.watch(profileControllerProvider.notifier).orders;

    // Trigger lazy loading for user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentUser != null && orders.isEmpty && !isLoading) {
        ref.read(profileControllerProvider.notifier).loadUserData();
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        color: AppColors.cyan,
        backgroundColor: theme.colorScheme.surface,
        onRefresh: () => ref.read(profileControllerProvider.notifier).loadUserData(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(context, theme),
            SliverToBoxAdapter(
              child: _buildBody(context, ref, currentUser, isLoading, orders),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    dynamic currentUser,
    bool isLoading,
    List orders,
  ) {
    if (isLoading && orders.isEmpty) {
      return Container(
        height: 400,
        alignment: Alignment.center,
        child: const _TechnicalLoader(),
      );
    }

    if (currentUser == null) {
      return const LoginPromptCard();
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => context.push(AppRoutes.editUserInfo),
          child: const ProfileHeader(),
        ),
        const SizedBox(height: 16),
        const QuickActionsRow(),
        const SizedBox(height: 24),
        const PurchaseStatsCard(),
        const SizedBox(height: 24),
        const RecentOrdersList(),
        const SizedBox(height: 24),
        const SavedAddressesList(),
        const SizedBox(height: 24),
        const AccountSettingsList(),
        const SizedBox(height: 24),
        _buildSignOutButton(context, ref),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 60,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Text(
        AppLocalizations.of(context)!.myAccount.toUpperCase(),
        style: const TextStyle(
          color: AppColors.cyan,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
          letterSpacing: 2,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 0.5,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: AppColors.cyan.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () async {
          await ref.read(profileControllerProvider.notifier).signOut();
        },
        child: Stack(
          children: [
            ClipPath(
              clipper: CyberpunkShapeClipper(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.05),
                  border: Border.all(color: AppColors.error, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: AppColors.error),
                    const SizedBox(width: 12),
                    Text(
                      AppLocalizations.of(context)!.signOut.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Container(width: 6, height: 6, color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }
}

class _TechnicalLoader extends StatelessWidget {
  const _TechnicalLoader();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(color: AppColors.cyan),
        const SizedBox(height: 16),
        Text(
          "LOADING_PROFILE_DATA...",
          style: TextStyle(
            fontFamily: 'monospace',
            color: AppColors.cyan.withValues(alpha: 0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

