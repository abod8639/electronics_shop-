import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/profile/data/models/address_model.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/address_controller.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class AddressForm extends ConsumerStatefulWidget {
  final AddressModel? address;
  const AddressForm({super.key, this.address});

  @override
  ConsumerState<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<AddressForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(addressControllerProvider.notifier).fillForm(widget.address);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addressState = ref.watch(addressControllerProvider).value;
    final controllerNotifier = ref.watch(addressControllerProvider.notifier);
    final isLoading = addressState?.isLoading ?? false;
    final selectedLabel = addressState?.selectedLabel ?? 'Home';
    final intl10n = AppLocalizations.of(context)!;

    return Container(
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(intl10n),
              const SizedBox(height: 24),
              _buildLocationScanner(controllerNotifier, intl10n, isLoading),
              const SizedBox(height: 24),
              _buildSectionTitle('IDENTITY_DATACAST'),
              const SizedBox(height: 12),
              _buildField(controllerNotifier.fullNameController, intl10n.fullName.toUpperCase()),
              const SizedBox(height: 16),
              _buildField(
                controllerNotifier.phoneController,
                intl10n.phoneNumber.toUpperCase(),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('COORDS_SPEC'),
              const SizedBox(height: 12),
              _buildField(controllerNotifier.streetController, intl10n.streetAddress.toUpperCase()),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildField(controllerNotifier.cityController, intl10n.city.toUpperCase()),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildField(controllerNotifier.stateController, intl10n.state.toUpperCase()),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      controllerNotifier.postalCodeController,
                      intl10n.postalCode.toUpperCase(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildField(
                      controllerNotifier.countryController,
                      intl10n.country.toUpperCase(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('TAG_PROTOCOL'),
              const SizedBox(height: 12),
              _buildLabelSelector(controllerNotifier, selectedLabel, context),
              const SizedBox(height: 32),
              _buildSubmitButton(controllerNotifier, isLoading, intl10n),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.gps_fixed_rounded, color: AppColors.cyan, size: 20),
            const SizedBox(width: 12),
            Text(
              (widget.address == null ? l10n.addNewAddress : l10n.editAddress).toUpperCase(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: AppColors.cyan,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'NAV_TARGET_V1.2 // SECURE_LINK_ACTIVE',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: AppColors.cyan.withValues(alpha: 0.5),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(width: 8, height: 2, color: AppColors.magenta),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.magenta,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationScanner(AddressController controller, AppLocalizations l10n, bool isLoading) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () async {
              try {
                final future = controller.getCurrentLocation();
                setState(() {}); // Show loading
                await future;
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } finally {
                if (mounted) setState(() {}); // Refresh with data/hide loading
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.cyan.withValues(alpha: 0.05),
          border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.cyan),
              )
            else
              const Icon(Icons.radar_rounded, color: AppColors.cyan, size: 20),
            const SizedBox(width: 12),
            Text(
              (isLoading ? 'SCANNING_GEO_DATA...' : l10n.useCurrentLocation).toUpperCase(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.cyan,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) {
    return Builder(
      builder: (context) {
        final intl10n = AppLocalizations.of(context)!;
        return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontFamily: 'monospace', fontSize: 10, letterSpacing: 1),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.cyan.withValues(alpha: 0.2)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.cyan),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.error),
            ),
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.05),
          ),
          validator: (v) => v!.isEmpty ? intl10n.thisFieldIsRequired : null,
        );
      },
    );
  }

  Widget _buildLabelSelector(
    AddressController controller,
    String selectedLabel,
    BuildContext context,
  ) {
    final intl10n = AppLocalizations.of(context)!;
    return Row(
      children: [intl10n.home, intl10n.work, intl10n.other]
          .map(
            (label) => Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.updateLabel(label);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedLabel == label ? AppColors.cyan : Colors.transparent,
                    border: Border.all(
                      color: selectedLabel == label ? AppColors.cyan : AppColors.cyan.withValues(alpha: 0.2),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: selectedLabel == label ? Colors.black : AppColors.cyan,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSubmitButton(AddressController controller, bool isLoading, AppLocalizations l10n) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () async {
              if (_formKey.currentState!.validate()) {
                setState(() {});
                await controller.saveAddress(widget.address?.id);
                if (mounted) {
                  setState(() {});
                  Navigator.of(context).pop();
                }
              }
            },
      child: Stack(
        children: [
          ClipPath(
            clipper: CyberpunkShapeClipper(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.cyan,
                boxShadow: [
                  BoxShadow(color: AppColors.cyan.withValues(alpha: 0.3), blurRadius: 15),
                ],
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : Text(
                        (widget.address == null ? l10n.save : l10n.update).toUpperCase(),
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
}

