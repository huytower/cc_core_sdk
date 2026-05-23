import 'package:app_config/core/enum/routing_manager_enum.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/navigation/route_names.dart';

/// Handles application routing configuration and route resolution.
///
/// Route values can be overridden from the root env files in `/env`.
class RouteDatasource {
  static const String _envRoutingManager = 'ROUTING_MANAGER';
  static const String _envStartRoute = 'ROUTE_START';

  static const RoutingManagerEnum _defaultStrategy =
      RoutingManagerEnum.AUTO_ROUTE;
  static const AppRoute _defaultStartRoute = AppRoute.comment;

  const RouteDatasource();

  String getStartRoute() => startRoute.path;

  static RoutingManagerEnum get currentStrategy {
    final rawStrategy = dotenv.maybeGet(
      _envRoutingManager,
      fallback: _defaultStrategy.name,
    );
    return _parseRoutingManager(rawStrategy) ?? _defaultStrategy;
  }

  static AppRoute get startRoute {
    final rawRoute = dotenv.maybeGet(
      _envStartRoute,
      fallback: _defaultStartRoute.name,
    );
    return appRouteFromString(rawRoute) ?? _defaultStartRoute;
  }

  static RoutingManagerEnum? _parseRoutingManager(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return RoutingManagerEnum.values.firstWhere(
      (value) => value.name.toUpperCase() == raw.trim().toUpperCase(),
      orElse: () => _defaultStrategy,
    );
  }
}
