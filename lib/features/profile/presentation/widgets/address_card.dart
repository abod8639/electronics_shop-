import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/profile/data/models/address_model.dart';
import 'package:electronics_shop/core/utils/functions/show_address_form.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/address_controller.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class AddressCard extends ConsumerWidget {
  final AddressModel address;

  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: address.isDefault ? AppColors.cyan.withValues(alpha: 0.1) : Colors.transparent,
            blurRadius: 15,
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkCardClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.9),
            border: Border.all(
              color: address.isDefault ? AppColors.cyan : AppColors.cyan.withValues(alpha: 0.2),
              width: address.isDefault ? 1 : 0.5,
            ),
          ),
          child: Column(
            children: [
              _buildMapPreview(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCardTopRow(context),
                    const SizedBox(height: 12),
                    _buildAddressDetails(theme),
                    const SizedBox(height: 16),
                    _buildActionButtons(context, ref),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cyan.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(color: AppColors.cyan.withValues(alpha: 0.1)),
        ),
      ),
      child: Stack(
        children: [
          if (address.latitude != null && address.longitude != null)
            _buildMapWidget(LatLng(address.latitude!, address.longitude!))
          else
            FutureBuilder<List<Location>>(
              future: _geocodeAddress(address.fullAddress),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final loc = snapshot.data!.first;
                  return _buildMapWidget(LatLng(loc.latitude, loc.longitude));
                }
                return _buildMapPlaceholder();
              },
            ),
          _buildMapOverlay(),
        ],
      ),
    );
  }

  Widget _buildMapOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.2),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                width: double.infinity,
                color: AppColors.cyan.withValues(alpha: 0.1),
                child: const Text(
                  'TERRAIN_SCAN_ACTIVE',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 8, color: AppColors.cyan),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    color: AppColors.cyan.withValues(alpha: 0.2),
                    child: const Text(
                      'GPS_LOCKED',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 8, color: AppColors.cyan),
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

  Future<List<Location>> _geocodeAddress(String address) async {
    try {
      return await locationFromAddress(address);
    } catch (_) {
      return [];
    }
  }

  Widget _buildMapWidget(LatLng position) {
    return GoogleMap(
      key: ValueKey('map_${address.id}_${position.latitude}'),
      initialCameraPosition: CameraPosition(target: position, zoom: 15),
      liteModeEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      markers: {
        Marker(
          markerId: MarkerId(address.id.toString()),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        ),
      },
    );
  }

  Widget _buildMapPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, color: AppColors.cyan.withValues(alpha: 0.2), size: 32),
          const SizedBox(height: 8),
          const Text(
            'SIGNAL_LOST',
            style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTopRow(BuildContext context) {
    final intl10n = AppLocalizations.of(context)!;
    IconData labelIcon = Icons.location_on_rounded;
    if (address.label?.toLowerCase() == intl10n.home.toLowerCase()) labelIcon = Icons.home_rounded;
    if (address.label?.toLowerCase() == intl10n.work.toLowerCase()) labelIcon = Icons.work_rounded;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.cyan.withValues(alpha: 0.05),
            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
          ),
          child: Icon(labelIcon, color: AppColors.cyan, size: 16),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (address.label ?? 'OTHER').toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w900, fontFamily: 'monospace', fontSize: 14),
            ),
            const Text(
              'TARGET_LINK_ESTABLISHED',
              style: TextStyle(fontFamily: 'monospace', fontSize: 8, color: AppColors.cyan),
            ),
          ],
        ),
        const Spacer(),
        if (address.isDefault) _buildDefaultBadge(),
      ],
    );
  }

  Widget _buildDefaultBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: const BoxDecoration(color: AppColors.cyan),
      child: const Text(
        'PRIMARY',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: Colors.black,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  Widget _buildAddressDetails(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cyan.withValues(alpha: 0.03),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (address.fullName ?? '').toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            address.fullAddress.toUpperCase(),
            style: TextStyle(
              color: AppColors.cyan.withValues(alpha: 0.7),
              fontSize: 10,
              fontFamily: 'monospace',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    final controller = ref.read(addressControllerProvider.notifier);
    final intl10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        if (!address.isDefault)
          Expanded(
            child: TextButton(
              onPressed: () => controller.setDefaultAddress(address.id),
              child: Text(
                intl10n.setDefault.toUpperCase(),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: AppColors.magenta),
              ),
            ),
          ),
        const Spacer(),
        _buildSmallButton(
          icon: Icons.edit_outlined,
          onTap: () => showAddressForm(context, address: address),
        ),
        const SizedBox(width: 8),
        _buildSmallButton(
          icon: Icons.delete_outline_rounded,
          color: AppColors.error,
          onTap: () => _confirmDelete(context, controller),
        ),
      ],
    );
  }

  Widget _buildSmallButton({required IconData icon, required VoidCallback onTap, Color color = AppColors.cyan}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AddressController controller) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipPath(
          clipper: CyberpunkCardClipper(),
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'CONFIRM_WIPE',
                  style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, color: AppColors.error),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Are you sure you want to remove this navigation target?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL', style: TextStyle(fontFamily: 'monospace', color: AppColors.cyan)),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                        onPressed: () {
                          controller.deleteAddress(address.id);
                          Navigator.pop(context);
                        },
                        child: const Text('DELETE', style: TextStyle(fontFamily: 'monospace', color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

