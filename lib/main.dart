import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:v2x/core/assets/localizations/feature_based_assets_loader.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/navigation/navigation_router.dart';
import 'package:v2x/core/notifiers/locale_notifier.dart';
import 'package:v2x/core/prefs/language_prefs.dart';
import 'package:v2x/core/services/networkconnectivity/network_connectivity_service.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/features/common/presentation/nointernet/no_internet_overlay.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await EasyLocalization.ensureInitialized();
  await NetworkConnectivityService.instance.init();
  final startLocale = await loadSavedLocale();
  initLocalNotifier(startLocale);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      startLocale: startLocale,
      path: 'lib/core/assets/localizations',
      assetLoader: const FeatureBasedAssetLoader(),
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      child: MyApp(),
    ),
  );
}

void initLocalNotifier(Locale startLocale) async {
  getIt.registerSingleton<LocaleNotifier>(
    LocaleNotifier(
      await EasyLocalization.ensureInitialized().then(
        (_) => const Locale('en'),
      ), // Fallback if needed
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeNotifier = getIt<LocaleNotifier>();
    localeNotifier.changeLocale(context.locale);

    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, _, __) {
        return MaterialApp.router(
          routerConfig: router,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          title: 'V2X',
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.white,
            fontFamily: 'Cairo',
            textTheme: ThemeData.light().textTheme,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.secondary),
            useMaterial3: true,
          ),
          builder:
              (context, child) =>
                  NoInternetOverlay(child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
}
