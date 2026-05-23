import 'dart:async';

import 'package:catcher_2/catcher_2.dart';
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';
import 'package:theme/core/utils/theme_utils.dart';
import 'package:theme/presentation/provider/theme_provider.dart';

import '../../core/navigation/config/auto_route/app_router.dart';

// ---------------------------------------------------------------------------
// Base
// ---------------------------------------------------------------------------

/// Contract for routing strategies.
///
/// Subclasses supply a specific router widget (e.g. [MaterialApp.router]).
/// The shared theme / localisation wiring lives in [buildThemedApp] and is
/// written only once.
abstract class RoutingStrategy {
  final ThemeProvider _themeProvider;

  final StreamController<ThemeMode> _themeModeController =
      StreamController<ThemeMode>.broadcast();

  late final VoidCallback _themeListener;

  RoutingStrategy(this._themeProvider) {
    _themeListener = () => _themeModeController.add(_themeProvider.themeMode);
    _themeProvider.addListener(_themeListener);
  }

  // -- public API -----------------------------------------------------------

  /// Builds the fully-configured application widget.
  Widget buildApp();

  /// Reactive stream of [ThemeMode] updates — use with `listen` / `StreamBuilder`.
  Stream<ThemeMode> get themeModeChanges => _themeModeController.stream;

  /// Subscribes [listener] to theme changes.
  /// Returns an *unsubscribe* callback for easy cleanup.
  VoidCallback onThemeChanged(VoidCallback listener) {
    _themeProvider.addListener(listener);
    return () => _themeProvider.removeListener(listener);
  }

  /// Releases resources held by this strategy.
  @mustCallSuper
  void dispose() {
    _themeProvider.removeListener(_themeListener);
    _themeModeController.close();
  }

  // -- shared builder -------------------------------------------------------

  /// Wraps [routerBuilder] with the common [ChangeNotifierProvider],
  /// [Consumer<ThemeProvider>], and [CcLocalization] layers.
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
}

// ---------------------------------------------------------------------------
// AutoRoute implementation
// ---------------------------------------------------------------------------

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
