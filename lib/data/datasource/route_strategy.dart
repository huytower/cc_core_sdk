import 'package:catcher_2/catcher_2.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme/core/utils/theme_utils.dart';
import 'package:theme/presentation/provider/theme_provider.dart';

import '../../core/navigation/config/auto_route/app_router.dart';

abstract class RoutingStrategy {
  Widget build();
}

class AutoRouteStrategy implements RoutingStrategy {
  @override
  Widget build() {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return CcLocalization.wrapWithLocalization(
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: createLightTheme(),
              darkTheme: createDarkTheme(),
              themeMode: themeProvider.themeMode,
              routerConfig: AppRouter(navigatorKey: Catcher2.navigatorKey).config(),
              locale: CcLocalization.getCurrentLocale(context),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
            ),
          );
        },
      ),
    );
  }
}
