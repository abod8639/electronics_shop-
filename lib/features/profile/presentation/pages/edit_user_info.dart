import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/functions/update_profile.dart';
import 'package:electronics_shop/features/auth/presentation/controllers/auth_controller.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class EditUserInfoView extends ConsumerStatefulWidget {
  const EditUserInfoView({super.key});

  @override
  ConsumerState<EditUserInfoView> createState() => _EditUserInfoViewState();
}

class _EditUserInfoViewState extends ConsumerState<EditUserInfoView> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).value;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    nameController = TextEditingController(
      text: user?.name ?? firebaseUser?.displayName ?? '',
    );
    emailController = TextEditingController(
      text: user?.email ?? firebaseUser?.email ?? '',
    );
    phoneController = TextEditingController(
      text: user?.phone ?? firebaseUser?.phoneNumber ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(authControllerProvider);
    final user = userState.value;
    final isLoading = userState.isLoading;
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          localizations.editProfile.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.cyan,
      ),
      body: Stack(
        children: [
          const BackGrid(accentColor: AppColors.cyan),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPhotoSection(user?.photoUrl),
                  const SizedBox(height: 40),
                  ClipPath(
                    clipper: CyberpunkCardClipper(),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.9),
                        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildDiagnosticHeader(),
                          const SizedBox(height: 24),
                          _buildTechnicalField(
                            controller: nameController,
                            label: "NAME_PARAMETER",
                            hint: localizations.fullName,
                            icon: Icons.person_search_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) return localizations.enterName;
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTechnicalField(
                            controller: emailController,
                            label: "COMM_CHANNEL_ID",
                            hint: localizations.email,
                            icon: Icons.alternate_email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) return localizations.enterEmail;
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return localizations.validEmail;
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTechnicalField(
                            controller: phoneController,
                            label: "VOICE_LINK_NUM",
                            hint: 'رقم الهاتف',
                            icon: Icons.phone_android_rounded,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value != null && value.isNotEmpty && value.length < 10) return 'INVALID_NUM_FORMAT';
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          _buildActionButtons(isLoading),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(String? photoUrl) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.magenta.withValues(alpha: 0.2), width: 1),
            ),
          ),
          // Rotating-like border
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.magenta, width: 2),
              boxShadow: [
                BoxShadow(color: AppColors.magenta.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: 2),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                child: ClipOval(
                  child: photoUrl != null
                      ? Image.network(photoUrl, fit: BoxFit.cover)
                      : const Icon(Icons.person, size: 60, color: AppColors.magenta),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('BIO_UPDATE_PENDING: Coming Soon', style: TextStyle(fontFamily: 'monospace')),
                    backgroundColor: AppColors.magenta,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppColors.magenta, shape: BoxShape.circle),
                child: const Icon(Icons.sync_rounded, color: Colors.black, size: 20),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Text(
              "BIO_SCAN",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: AppColors.magenta.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticHeader() {
    return Row(
      children: [
        Container(width: 4, height: 24, color: AppColors.cyan),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "IDENTITY_OVERRIDE_PROTOCOL",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: AppColors.cyan,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              "SYSTEM_STATE: [MODIFICATION_MODE]",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 8,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTechnicalField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            color: AppColors.cyan.withValues(alpha: 0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontFamily: 'monospace', color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 12),
            prefixIcon: Icon(icon, color: AppColors.cyan, size: 18),
            filled: true,
            fillColor: AppColors.cyan.withValues(alpha: 0.05),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.cyan.withValues(alpha: 0.3)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.cyan, width: 1.5),
            ),
            errorStyle: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: AppColors.error),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isLoading) {
    return Column(
      children: [
        GestureDetector(
          onTap: isLoading
              ? null
              : () async {
                  if (formKey.currentState!.validate()) {
                    await updateProfile(
                      ref,
                      nameController.text.trim(),
                      emailController.text.trim(),
                      phoneController.text.trim(),
                    );
                  }
                },
          child: Stack(
            children: [
              ClipPath(
                clipper: CyberpunkShapeClipper(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                    color: AppColors.cyan,
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                        : const Text(
                            "COMMIT_CHANGES",
                            style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 2),
                          ),
                  ),
                ),
              ),
              Positioned(right: 0, bottom: 0, child: Container(width: 8, height: 8, color: Colors.black)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "ABORT_CONNECTION".toUpperCase(),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: AppColors.magenta.withValues(alpha: 0.7),
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}

