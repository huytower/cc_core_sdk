import 'package:catcher_2/catcher_2.dart';
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme/core/utils/theme_utils.dart';
import 'package:theme/presentation/provider/theme_provider.dart';

import '../../core/navigation/config/auto_route/app_router.dart';

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
          return CcLocalization.wrapWithLocalization(
            child: Builder(
              builder: (context) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  theme: createLightTheme(),
                  darkTheme: createDarkTheme(),
                  themeMode: themeProvider.themeMode,
                  routerConfig: routerConfig,
                  locale: CcLocalization.getCurrentLocale(context),
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
