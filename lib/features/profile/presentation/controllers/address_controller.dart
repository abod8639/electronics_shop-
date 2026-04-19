import 'package:electronics_shop/features/auth/presentation/controllers/auth_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:electronics_shop/features/profile/domain/repositories/address_repository.dart';
import 'package:electronics_shop/features/profile/data/datasources/address_service.dart';
import 'package:flutter/material.dart';
import 'package:electronics_shop/features/profile/data/models/address_model.dart';

part 'address_controller.g.dart';

const String _defaultLabel = 'Home';

class AddressState {
  final List<AddressModel> addresses;
  final bool isLoading;
  final String selectedLabel;

  AddressState({
    this.addresses = const [],
    this.isLoading = false,
    this.selectedLabel = _defaultLabel,
  });

  AddressState copyWith({
    List<AddressModel>? addresses,
    bool? isLoading,
    String? selectedLabel,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      selectedLabel: selectedLabel ?? this.selectedLabel,
    );
  }
}

@riverpod
class AddressController extends _$AddressController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final countryController = TextEditingController();

  double? _latitude;
  double? _longitude;

  @override
  FutureOr<AddressState> build() async {
    // Watch auth state to reset if needed
    ref.watch(authControllerProvider);

    ref.onDispose(() {
      fullNameController.dispose();
      phoneController.dispose();
      streetController.dispose();
      cityController.dispose();
      stateController.dispose();
      postalCodeController.dispose();
      countryController.dispose();
    });

    final repository = ref.watch(addressRepositoryProvider);
    final cached = repository.getCachedAddresses();
    return AddressState(addresses: cached);
  }

  void _updateState({
    List<AddressModel>? addresses,
    bool? isLoading,
    String? selectedLabel,
  }) {
    final current = state.value ?? AddressState();
    state = AsyncData(current.copyWith(
      addresses: addresses,
      isLoading: isLoading,
      selectedLabel: selectedLabel,
    ));
  }

  Future<void> fetchAddresses() async {
    state = const AsyncLoading();
    final repository = ref.read(addressRepositoryProvider);
    try {
      final fetched = await repository.getAddresses();
      _updateState(addresses: fetched, isLoading: false);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteAddress(int id) async {
    _updateState(isLoading: true);
    try {
      final repository = ref.read(addressRepositoryProvider);
      await repository.deleteAddress(id);
      final currentAddresses = state.value?.addresses ?? [];
      _updateState(
        addresses: currentAddresses.where((addr) => addr.id != id).toList(),
        isLoading: false,
      );
    } catch (e) {
      _updateState(isLoading: false);
      rethrow;
    }
  }

  Future<void> setDefaultAddress(int id) async {
    _updateState(isLoading: true);
    try {
      final repository = ref.read(addressRepositoryProvider);
      await repository.setDefaultAddress(id);
      await fetchAddresses();
    } finally {
      _updateState(isLoading: false);
    }
  }

  void fillForm(AddressModel? address) {
    if (address == null) {
      clearForm();
      _updateState(selectedLabel: _defaultLabel);
      return;
    }
    fullNameController.text = address.fullName ?? '';
    phoneController.text = address.phone ?? '';
    streetController.text = address.street;
    cityController.text = address.city;
    stateController.text = address.state ?? '';
    postalCodeController.text = address.postalCode ?? '';
    countryController.text = address.country ?? '';
    _latitude = address.latitude;
    _longitude = address.longitude;
    _updateState(selectedLabel: address.label ?? _defaultLabel);
  }

  Future<void> saveAddress(int? id) async {
    final model = AddressModel(
      id: id ?? 0,
      fullName: fullNameController.text,
      phone: phoneController.text,
      street: streetController.text,
      city: cityController.text,
      state: stateController.text,
      postalCode: postalCodeController.text,
      country: countryController.text,
      label: state.value?.selectedLabel ?? _defaultLabel,
      isDefault: false,
      latitude: _latitude,
      longitude: _longitude,
    );

    _updateState(isLoading: true);
    try {
      final repository = ref.read(addressRepositoryProvider);
      if (id == null) {
        await repository.createAddress(model);
      } else {
        await repository.updateAddress(id, model);
      }
      await fetchAddresses();
      clearForm();
    } finally {
      _updateState(isLoading: false);
    }
  }

  Future<void> getCurrentLocation() async {
    _updateState(isLoading: true);
    try {
      final service = ref.read(addressServiceProvider);
      final position = await service.getCurrentPosition();
      final place = await service.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (place != null) {
        streetController.text = place.street ?? '';
        cityController.text = place.locality ?? '';
        stateController.text = place.administrativeArea ?? '';
        postalCodeController.text = place.postalCode ?? '';
        countryController.text = place.country ?? '';
        _latitude = position.latitude;
        _longitude = position.longitude;
      } else {
        throw 'لم يتم العثور على تفاصيل العنوان لهذا الموقع';
      }
    } finally {
      _updateState(isLoading: false);
    }
  }

  void updateLabel(String label) {
    _updateState(selectedLabel: label);
  }

  void clearForm() {
    for (var c in [
      fullNameController,
      phoneController,
      streetController,
      cityController,
      stateController,
      postalCodeController,
      countryController,
    ]) {
      c.clear();
    }
    _latitude = null;
    _longitude = null;
  }
}
