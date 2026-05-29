import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/navigation/route_names.dart';

/// Handles application routing configuration and route resolution
class RouteDatasource {
  static const String _envAutoRouteStart = 'AUTO_ROUTE_START';

  const RouteDatasource();

  String getStartRoute() => autoRouteStart.path;

  static AppRoute get autoRouteStart {
    const _defaultAutoRouteStart = AppRoute.dashboard;
    final rawRoute = dotenv.maybeGet(
      _envAutoRouteStart,
      fallback: _defaultAutoRouteStart.name,
    );
    return appRouteFromString(rawRoute) ?? _defaultAutoRouteStart;
  }
}
