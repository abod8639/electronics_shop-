import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _removeNativeSplash();
  }

  Future<void> _removeNativeSplash() async {
    // We wait for the custom animation in the view to finish
    // then we hide the native splash.
    // However, the preserve() should be called in main.
    await Future.delayed(const Duration(milliseconds: 500));
    FlutterNativeSplash.remove();
  }
}
