import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/theme_controller.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/language_controller.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:electronics_shop/routes/routes.dart';

class AccountSettingsList extends ConsumerWidget {
  const AccountSettingsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(themeControllerProvider);
    final themeNotifier = ref.watch(themeControllerProvider.notifier);
    final languageNotifier = ref.watch(languageControllerProvider.notifier);
    final currentLocale = ref.watch(languageControllerProvider);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.05),
            blurRadius: 30,
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkCardClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.8),
            border: Border.all(
              color: AppColors.cyan.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, localizations.accountSettings),
              _buildSettingItem(
                context: context,
                icon: Icons.person_outline,
                title: localizations.editProfile,
                subtitle: 'USER_IDENTITY_MOD',
                onTap: () => context.push(AppRoutes.editUserInfo),
              ),
              _buildDivider(),
              _buildSettingItem(
                context: context,
                icon: isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                title: localizations.theme,
                subtitle: isDarkMode ? 'SHADOW_PROTOCOL' : 'LUX_EMISSION',
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (val) => themeNotifier.toggleTheme(),
                  activeColor: AppColors.cyan,
                  activeTrackColor: AppColors.cyan.withValues(alpha: 0.2),
                  inactiveThumbColor: AppColors.grey,
                  inactiveTrackColor: AppColors.grey.withValues(alpha: 0.1),
                ),
                onTap: () => themeNotifier.toggleTheme(),
              ),
              _buildDivider(),
              _buildSettingItem(
                context: context,
                icon: Icons.notifications_outlined,
                title: localizations.notifications,
                subtitle: 'NEURAL_LINK_ALERTS',
                onTap: () {},
              ),
              _buildDivider(),
              _buildSettingItem(
                context: context,
                icon: Icons.language_outlined,
                title: localizations.language,
                subtitle: 'LINGUA_CORE_V2',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.magenta.withValues(alpha: 0.1),
                    border: Border.all(color: AppColors.magenta.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    languageNotifier.currentLanguageName.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.magenta,
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () => _showLanguageDialog(context, ref, currentLocale, localizations),
              ),
              _buildDivider(),
              _buildSettingItem(
                context: context,
                icon: Icons.help_outline,
                title: localizations.helpSupport,
                subtitle: 'TECH_ASSIST_MODULE',
                onTap: () {},
              ),
              _buildDivider(),
              _buildSettingItem(
                context: context,
                icon: Icons.info_outline,
                title: localizations.about,
                subtitle: 'SYS_MANIFEST_VER_1_0',
                isLast: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cyan.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.settings_applications, color: AppColors.cyan, size: 20),
          const SizedBox(width: 12),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              color: AppColors.cyan,
              letterSpacing: 2,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          const Text(
            'CONFIG_RUNNING',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 8,
              color: AppColors.cyan,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Locale currentLocale,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipPath(
          clipper: CyberpunkCardClipper(),
          child: Container(
            padding: const EdgeInsets.all(2), // Border effect
            decoration: const BoxDecoration(color: AppColors.cyan),
            child: ClipPath(
              clipper: CyberpunkCardClipper(),
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.language, color: AppColors.cyan),
                        const SizedBox(width: 12),
                        Text(
                          l10n.language.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            color: AppColors.cyan,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(height: 1, color: AppColors.cyan.withValues(alpha: 0.1)),
                    const SizedBox(height: 16),
                    _buildLanguageOption(
                      context: context,
                      title: l10n.english.toUpperCase(),
                      value: 'en',
                      groupValue: currentLocale.languageCode,
                      onChanged: () {
                        ref.read(languageControllerProvider.notifier).changeLanguage(const Locale('en'));
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildLanguageOption(
                      context: context,
                      title: l10n.arabic.toUpperCase(),
                      value: 'ar',
                      groupValue: currentLocale.languageCode,
                      onChanged: () {
                        ref.read(languageControllerProvider.notifier).changeLanguage(const Locale('ar'));
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String value,
    required String groupValue,
    required VoidCallback onChanged,
  }) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: onChanged,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cyan.withValues(alpha: 0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.cyan : AppColors.cyan.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'monospace',
                color: isSelected ? AppColors.cyan : Colors.white70,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal,
                letterSpacing: 1,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle_outline, color: AppColors.cyan, size: 18),
            if (!isSelected)
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Stack(
      children: [
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              highlightColor: AppColors.cyan.withValues(alpha: 0.1),
              splashColor: AppColors.cyan.withValues(alpha: 0.05),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.05),
                  border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
                ),
                child: Icon(icon, color: AppColors.cyan, size: 18),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1.1,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          color: AppColors.cyan.withValues(alpha: 0.5),
                          letterSpacing: 0.5,
                        ),
                      ),
                  ],
                ),
              ),
              trailing ?? const Icon(Icons.chevron_right, color: AppColors.cyan, size: 16),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            color: AppColors.magenta.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.cyan.withValues(alpha: 0.1),
    );
  }
}


