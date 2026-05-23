import 'package:injectable/injectable.dart';
import 'package:theme/presentation/provider/theme_provider.dart';

/// Provides routing-layer dependencies that originate from external packages.
@module
abstract class RouteStrategyModule {
  /// Single [ThemeProvider] instance shared across all routing strategies.
  @lazySingleton
  ThemeProvider provideThemeProvider() => ThemeProvider();
}
