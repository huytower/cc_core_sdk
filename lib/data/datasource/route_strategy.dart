import 'package:app_config/core/enum/routing_manager_enum.dart';
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
      routerConfig: AppRouter().config(),
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

// Routing Configuration

/// Provides access to all available routing strategies
class RouteStrategyProvider {
  /// Gets the appropriate routing strategy based on the provided enum
  static RoutingStrategy getStrategy(RoutingManagerEnum manager) {
    return _routingStrategies[manager] ?? _getDefaultStrategy();
  }

  /// Gets the default routing strategy
  static RoutingStrategy _getDefaultStrategy() {
    return _routingStrategies[RoutingManagerEnum.AUTO_ROUTE]!;
  }

  /// Map of all available routing strategies
  static final Map<RoutingManagerEnum, RoutingStrategy> _routingStrategies = {
    RoutingManagerEnum.AUTO_ROUTE: AutoRouteStrategy(),
    RoutingManagerEnum.GETX: GetxRouteStrategy(),
  };
}

/// Returns the main app UI for the given navigate manager
Widget buildAppByRoutingManager(RoutingManagerEnum manager) {
  return RouteStrategyProvider.getStrategy(manager).build();
}
