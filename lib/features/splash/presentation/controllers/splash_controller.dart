import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashController {
  SplashController() {
    _removeNativeSplash();
  }

  Future<void> _removeNativeSplash() async {
    await Future.delayed(const Duration(milliseconds: 500));
    FlutterNativeSplash.remove();
  }
}

final splashControllerProvider = Provider<SplashController>((ref) {
  return SplashController();
});
