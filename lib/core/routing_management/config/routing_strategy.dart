import 'package:app_config/enum/routing_manager_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:theme/cc_themes.dart';

import '../enum/page_name_enum.dart';
import 'auto_route/routing_manager.dart';
import 'getx/getx_routing_manager.dart';

/// Abstract strategy for routing
abstract class RoutingStrategy {
  Widget build();
}

class AutoRouteStrategy implements RoutingStrategy {
  @override
  Widget build() => MaterialApp.router(
        routerConfig: AppRouter().config(),
      );
}

class GetxRouteStrategy implements RoutingStrategy {
  @override
  Widget build() => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: CcThemes.darkTheme,
        initialRoute: getPageName(PageNameEnum.SPLASH),
        getPages: GetxRoutingManager.instance.getPages(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
        ],
      );
}

/// Map of routing strategies
final Map<RoutingManagerEnum, RoutingStrategy> routingStrategies = {
  RoutingManagerEnum.AUTO_ROUTE: AutoRouteStrategy(),
  RoutingManagerEnum.GETX: GetxRouteStrategy(),
};

/// Returns the main app widget for the given routing manager, or throws if not supported.
Widget buildAppByRoutingManager(RoutingManagerEnum manager) {
  final strategy = routingStrategies[manager];
  if (strategy != null) {
    return strategy.build();
  } else {
    throw UnimplementedError('Routing manager $manager is not supported.');
  }
}
