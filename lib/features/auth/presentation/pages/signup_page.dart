import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:electronics_shop/core/utils/functions/app_guard.dart';
import 'package:electronics_shop/features/auth/presentation/controllers/auth_controller.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class SignUpPage extends ConsumerStatefulWidget {
  final VoidCallback? onSignInTap;
  const SignUpPage({super.key, this.onSignInTap});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    AppGuard.runSafeInternet(ref, () async {
      if (_formKey.currentState!.validate()) {
        await ref
            .read(authControllerProvider.notifier)
            .signUpWithEmail(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              name: _nameController.text.trim(),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Listen to authentication errors
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'REGISTRY_ERROR: [${next.error}]\nLINK_TERMINATED',
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const BackGrid(accentColor: AppColors.magenta),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildTerminalHeader(localizations),
                    const SizedBox(height: 32),
                    ClipPath(
                      clipper: CyberpunkCardClipper(),
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(
                            alpha: 0.9,
                          ),
                          border: Border.all(
                            color: AppColors.magenta.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildDiagnosticModule(localizations),
                              const SizedBox(height: 24),
                              AuthTextField(
                                controller: _nameController,
                                label: localizations.fullName,
                                icon: const Icon(Icons.person_pin_rounded),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return localizations.enterName;
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              AuthTextField(
                                controller: _emailController,
                                label: localizations.email,
                                icon: const Icon(Icons.alternate_email_rounded),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return localizations.enterEmail;
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value))
                                    return localizations.validEmail;
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              AuthTextField(
                                controller: _passwordController,
                                label: localizations.password,
                                icon: const Icon(Icons.lock_open_rounded),
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return localizations.enterPassword;
                                  if (value.length < 6)
                                    return localizations.passwordLength;
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              AuthTextField(
                                controller: _confirmPasswordController,
                                label: localizations.confirmPassword,
                                icon: const Icon(Icons.lock_person_rounded),
                                isPassword: true,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return localizations.confirmYourPassword;
                                  if (value != _passwordController.text)
                                    return localizations.passwordsDoNotMatch;
                                  return null;
                                },
                              ),
                              const SizedBox(height: 32),
                              _buildSubmitButton(
                                authState.isLoading,
                                localizations,
                              ),
                              const SizedBox(height: 24),
                              _buildSocialAuth(localizations),
                              const SizedBox(height: 24),
                              _buildLoginRow(localizations),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.magenta,
              ),
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalHeader(AppLocalizations l10n) {
    return Column(
      children: [
        const Icon(
          Icons.person_add_rounded,
          color: AppColors.magenta,
          size: 64,
        ),
        const SizedBox(height: 16),
        Text(
          "NEW_USER_REGISTRY",
          style: TextStyle(
            fontFamily: 'monospace',
            color: AppColors.magenta.withValues(alpha: 0.5),
            fontSize: 10,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.createAccount.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: AppColors.magenta,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildDiagnosticModule(AppLocalizations l10n) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: AppColors.cyan),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "IDENTITY_REGISTRATION_SYSTEM",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: AppColors.cyan.withValues(alpha: 0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "STATUS: [NEW_ENTRY_PENDING]",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: AppColors.cyan.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isLoading, AppLocalizations l10n) {
    return GestureDetector(
      onTap: isLoading ? null : _onSignUpPressed,
      child: Stack(
        children: [
          ClipPath(
            clipper: CyberpunkShapeClipper(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.magenta,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.magenta.withValues(alpha: 0.3),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        l10n.signUp.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.black,
                          letterSpacing: 2,
                        ),
                      ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(width: 8, height: 8, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialAuth(AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => ref.read(authControllerProvider.notifier).signInWithGoogle(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cyan.withValues(alpha: 0.1),
          border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.g_mobiledata_rounded,
              color: AppColors.cyan,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              l10n.signInWithGoogle.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.cyan,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginRow(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.alreadyHaveAccount.toUpperCase(),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        TextButton(
          onPressed: widget.onSignInTap,
          child: Text(
            l10n.login.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w900,
              color: AppColors.magenta,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}
