import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/functions/show_address_form.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/address_controller.dart';
import 'package:electronics_shop/features/profile/presentation/widgets/address_card.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class SavedAddressesList extends ConsumerWidget {
  const SavedAddressesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final addressesState = ref.watch(addressControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, theme),
        const SizedBox(height: 8),
        addressesState.when(
          data: (addresses) => addresses.isEmpty
              ? _buildEmptyState(theme)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: addresses.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return AddressCard(address: address);
                  },
                ),
          loading: () => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CircularProgressIndicator(color: AppColors.cyan)),
          ),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'NAV_DATA_ERROR: $e',
                style: const TextStyle(fontFamily: 'monospace', color: AppColors.error),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final intl10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                color: AppColors.cyan,
              ),
              const SizedBox(width: 12),
              Text(
                intl10n.savedAddresses.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                  fontSize: 14,
                  color: AppColors.cyan,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => showAddressForm(context),
            child: Stack(
              children: [
                ClipPath(
                  clipper: CyberpunkShapeClipper(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withValues(alpha: 0.1),
                      border: Border.all(color: AppColors.cyan, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, color: AppColors.cyan, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          intl10n.addNew.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.cyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(width: 4, height: 4, color: AppColors.cyan),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 48,
              color: AppColors.cyan.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            const Text(
              'NO_COORD_DATA_FOUND',
              style: TextStyle(
                fontFamily: 'monospace',
                color: AppColors.grey,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

