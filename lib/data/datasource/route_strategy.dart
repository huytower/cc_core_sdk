import 'package:catcher_2/catcher_2.dart';
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';
import 'package:theme/core/utils/theme_utils.dart';
import 'package:theme/presentation/provider/theme_provider.dart';

import '../../core/navigation/config/auto_route/app_router.dart';

/// A strategy that builds the app shell and router widget.
///
/// This class isolates routing implementation details from app setup logic.
/// The shared theme and localization wiring is handled in one place.
abstract class RoutingStrategy {
  final ThemeProvider _themeProvider;

  const RoutingStrategy(this._themeProvider);

  /// Builds the fully-configured application widget.
  Widget buildApp();

  /// Wraps the router with shared app-level wiring.
  ///
  /// This keeps theme/localization/provider setup in one location and makes
  /// it easier for junior developers to understand the application shell.
  @protected
  Widget buildThemedApp(
    Widget Function(BuildContext context, ThemeProvider themeProvider)
        routerBuilder,
  ) {
    return ChangeNotifierProvider<ThemeProvider>.value(
      value: _themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return CcLocalization.wrapWithLocalization(
            child: Builder(
              builder: (context) => routerBuilder(context, themeProvider),
            ),
          );
        },
      ),
    );
  }

  /// Resources are owned by DI, so override only if this strategy needs cleanup.
  @disposeMethod
  @mustCallSuper
  void dispose() {}
}

/// [RoutingStrategy] backed by the `auto_route` package.
@LazySingleton(as: RoutingStrategy)
class AutoRouteStrategy extends RoutingStrategy {
  AutoRouteStrategy(ThemeProvider themeProvider) : super(themeProvider);

  @override
  Widget buildApp() {
    return buildThemedApp((context, themeProvider) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: createLightTheme(),
        darkTheme: createDarkTheme(),
        themeMode: themeProvider.themeMode,
        routerConfig: AppRouter(navigatorKey: Catcher2.navigatorKey).config(),
        locale: CcLocalization.getCurrentLocale(context),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
      );
    });
  }
}
