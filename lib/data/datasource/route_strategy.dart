import 'package:catcher_2/catcher_2.dart';
import 'package:content_locale/cc_localization.dart' as localization;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:theme/core/utils/theme_utils.dart';
import 'package:theme/presentation/provider/theme_provider.dart';

import '../../core/navigation/config/auto_route/app_router.dart';
import '../../core/navigation/config/getx/getx_router.dart';
import '../../core/navigation/enums/page_name_enum.dart';

/// Abstract base class for different routing strategies
abstract class RoutingStrategy {
  /// Builds the application with the appropriate routing configuration
  Widget build();
}

/// Implementation of RoutingStrategy using AutoRoute
class AutoRouteStrategy implements RoutingStrategy {
  @override
  Widget build() {
    return _buildThemedApp(
      routerConfig: AppRouter(navigatorKey: Catcher2.navigatorKey).config(),
    );
  }

  /// Builds the MaterialApp with theme and localization support
  Widget _buildThemedApp({required dynamic routerConfig}) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return localization.CcLocalization.wrapWithLocalization(
            child: Builder(builder: (context) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: createLightTheme(),
                darkTheme: createDarkTheme(),
                themeMode: themeProvider.themeMode,
                routerConfig: routerConfig,
                locale: localization.CcLocalization.getCurrentLocale(context),
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
              );
            }),
          );
        },
      ),
    );
  }
}

/// Implementation of RoutingStrategy using GetX
class GetxRouteStrategy implements RoutingStrategy {
  @override
  Widget build() {
    return _buildThemedApp(
      initialRoute: getPageName(PageNameEnum.SPLASH),
      getPages: GetxRoutingManager.instance.getPages(),
    );
  }

  /// Builds the GetMaterialApp with theme and localization support
  Widget _buildThemedApp({
    required String initialRoute,
    required List<GetPage> getPages,
  }) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return localization.CcLocalization.wrapWithLocalization(
            child: Builder(builder: (context) {
              return GetMaterialApp(
                navigatorKey: Catcher2.navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: createLightTheme(),
                darkTheme: createDarkTheme(),
                themeMode: themeProvider.themeMode,
                initialRoute: initialRoute,
                getPages: getPages,
                locale: localization.CcLocalization.getCurrentLocale(context),
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
              );
            }),
          );
        },
      ),
    );
  }
}
