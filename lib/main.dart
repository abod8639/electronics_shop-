import 'package:electronics_shop/core/constants/app_theme.dart';
import 'package:electronics_shop/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:electronics_shop/core/utils/functions/hive_init.dart';
import 'package:electronics_shop/core/utils/components/internet_connection_banner.dart';
import 'package:electronics_shop/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/language_controller.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/theme_controller.dart';
import 'package:electronics_shop/core/utils/components/grid_background.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await Hive.initFlutter();
  await hiveInit();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final isDarkMode = ref.watch(themeControllerProvider);
    final locale = ref.watch(languageControllerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      builder: (context, child) => Stack(
        children: [
          if (child != null) GridBackground(child: child),
          const Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: InternetConnectionBanner(title: "No internet connection" ),
          ),
        ],
      ),
    );
  }
}
