import 'package:hive/hive.dart';
import 'package:electronics_shop/features/profile/data/models/localized_string_model.dart';
import 'package:electronics_shop/features/product/data/models/category_model.dart';
import 'package:electronics_shop/features/product/data/models/image_url_model.dart';
import 'package:electronics_shop/features/product/data/models/product_category_model.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/product/data/models/product_size_model.dart';
import 'package:electronics_shop/features/cart/data/models/cart_item_model.dart';
import 'package:electronics_shop/features/order/data/models/order_model.dart';
import 'package:electronics_shop/features/profile/data/models/address_model.dart';
import 'package:electronics_shop/features/profile/data/models/user_model.dart';

Future<void> hiveInit() async {
  // Register Adapters
  Hive.registerAdapter(CartItemModelAdapter());
  Hive.registerAdapter(OrderModelAdapter());
  Hive.registerAdapter(OrderItemModelAdapter());
  Hive.registerAdapter(AddressModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());

  // Register new adapters for localized data
  Hive.registerAdapter(LocalizedStringAdapter());
  Hive.registerAdapter(ImageUrlAdapter());
  Hive.registerAdapter(ProductCategoryAdapter());
  Hive.registerAdapter(ProductSizeAdapter());

  // Open Boxes
  await _openBoxSafe<CartItemModel>('cart');
  await _openBoxSafe<String>('wishlist');
  await _openBoxSafe<ProductModel>('products');
  await _openBoxSafe<CategoryModel>('categories');
  await _openBoxSafe<AddressModel>('addresses');
  await _openBoxSafe<OrderModel>('orders');
  await _openBoxSafe<UserModel>('users');
  await _openBoxSafe('settings');
  await _openBoxSafe('auth_box');
  await _openBoxSafe<String>('search_history');
}

/// Opens a Hive box safely, clearing it if data is corrupted or schema has changed
Future<Box<T>> _openBoxSafe<T>(String name) async {
  try {
    return await Hive.openBox<T>(name);
  } catch (e) {
    // If opening fails (e.g. TypeError due to schema change), clear the box and try again
    await Hive.deleteBoxFromDisk(name);
    return await Hive.openBox<T>(name);
  }
}
