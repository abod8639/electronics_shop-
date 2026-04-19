import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:electronics_shop/core/config/api_config.dart';
import 'package:electronics_shop/core/services/api_service.dart';
import 'package:electronics_shop/core/errors/failures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:electronics_shop/features/profile/data/models/address_model.dart';

part 'address_service.g.dart';

@Riverpod(keepAlive: true)
AddressService addressService(AddressServiceRef ref) {
  return AddressService(ref.watch(apiServiceProvider));
}

class AddressService {
  final ApiService _apiService;

  AddressService(this._apiService);

  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await _apiService.get(ApiConfig.addresses);
      final data = response.data;
      final List<dynamic> addressesJson = data['addresses'] ?? [];
      return addressesJson
          .map((json) => AddressModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'فشل تحميل العناوين';
    }
  }

  Future<AddressModel> createAddress(AddressModel address) async {
    try {
      final Map<String, dynamic> addressData = address.toJson();
      _cleanAddressData(addressData);
      final response = await _apiService.post(
        ApiConfig.addresses,
        data: addressData,
      );
      final data = response.data;
      return AddressModel.fromJson(data['address'] as Map<String, dynamic>);
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'فشل إضافة العنوان';
    }
  }

  Future<AddressModel> updateAddress(int id, AddressModel address) async {
    try {
      final Map<String, dynamic> addressData = address.toJson();
      _cleanAddressData(addressData);
      final response = await _apiService.put(
        '${ApiConfig.addresses}/$id',
        data: addressData,
      );
      final data = response.data;
      return AddressModel.fromJson(data['address'] as Map<String, dynamic>);
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'فشل تحديث العنوان';
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      await _apiService.delete('${ApiConfig.addresses}/$id');
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'فشل حذف العنوان';
    }
  }

  Future<AddressModel> setDefaultAddress(int id) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.addresses}/$id/set-default',
      );
      final data = response.data;
      return AddressModel.fromJson(data['address'] as Map<String, dynamic>);
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'فشل تعيين العنوان الافتراضي';
    }
  }

  void _cleanAddressData(Map<String, dynamic> data) {
    data.removeWhere(
      (key, value) =>
          ['id', 'user_id', 'created_at', 'updated_at'].contains(key),
    );
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw 'خدمات الموقع معطلة. يرجى تفعيلها والمحاولة مرة أخرى.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'تم رفض صلاحيات الموقع. لا يمكننا تحديد موقعك تلقائياً.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'صلاحيات الموقع مرفوضة بشكل دائم. يرجى تفعيلها من إعدادات التطبيق.';
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      // Fallback to last known position if current fails or times out
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) return lastKnown;
      throw 'تعذر الحصول على موقعك الحالي. تأكد من وجود إشارة GPS.';
    }
  }

  Future<Placemark?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      return placemarks.isNotEmpty ? placemarks.first : null;
    } catch (e) {
      return null;
    }
  }
}
