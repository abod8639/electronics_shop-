import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:electronics_shop/features/order/data/models/order_model.dart';
import 'package:electronics_shop/features/profile/data/models/address_model.dart';
import 'package:electronics_shop/features/profile/data/models/user_model.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/address_controller.dart';
import 'package:electronics_shop/features/auth/presentation/controllers/auth_controller.dart';
import 'package:electronics_shop/features/order/presentation/controllers/orders_controller.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  void build() {
    // Listen for auth changes to clear data on logout
    // Using fireImmediately: false to avoid executing during the initial build
    ref.listen(authControllerProvider, (previous, next) {
      if (next.value == null && !next.isLoading && previous?.value != null) {
        // Use a microtask or similar to ensure we are outside the build cycle
        // and using ref safely.
        Future.microtask(() => _clearData());
      }
    });
  }

  UserModel? get currentUser => ref.watch(authControllerProvider).value;
  bool get isLoading => ref.watch(authControllerProvider).isLoading;

  List<OrderModel> get orders =>
      ref.watch(ordersControllerProvider).valueOrNull ?? [];
  List<AddressModel> get addresses =>
      ref.watch(addressControllerProvider).valueOrNull?.addresses ?? [];

  int get wishlistCount {
    try {
      if (Hive.isBoxOpen('wishlist')) {
        return Hive.box<String>('wishlist').length;
      }
    } catch (_) {}
    return 0;
  }

  void _clearData() {
    // We use try-catch and check if we can still use ref
    try {
      ref.read(ordersControllerProvider.notifier).clearData();
      ref.read(addressControllerProvider.notifier).clearForm();
    } catch (e) {
      // If ref is still not usable, we log and defer or ignore
      debugPrint("Could not clear data: $e");
    }
  }

  Future<void> loadUserData() async {
    if (currentUser == null) return;

    await Future.wait([
      ref.read(ordersControllerProvider.notifier).refreshOrders(),
      ref.read(addressControllerProvider.notifier).fetchAddresses(),
    ]);
  }

  int get totalOrders => orders.length;
  double get totalSpent =>
      orders.fold(0.0, (sum, order) => sum + order.totalAmount);
  int get deliveredOrders =>
      orders.where((o) => o.status.toLowerCase() == 'delivered').length;

  Future<void> signOut() async {
    await ref.read(authControllerProvider.notifier).signOut();
    _clearData();
  }

  Future<void> signInWithGoogle() async {
    await ref.read(authControllerProvider.notifier).signInWithGoogle();
  }
}
