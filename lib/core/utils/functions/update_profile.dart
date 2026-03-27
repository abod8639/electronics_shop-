import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/features/auth/presentation/controllers/auth_controller.dart';

Future<void> updateProfile(
  WidgetRef ref,
  String name,
  String email,
  String phone,
) async {
  await ref
      .read(authControllerProvider.notifier)
      .updateUserProfile(name: name, email: email, phone: phone);
}
