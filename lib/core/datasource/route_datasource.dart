import 'package:app_config/enum/routing_manager_enum.dart';

import '../navigation/enums/page_name_enum.dart';

/// Handles application routing configuration and route resolution
class RouteDatasource {
  final PageNameEnum _startRoute;

  // static const RoutingManagerEnum _currentStrategy = RoutingManagerEnum.GETX;
  static const RoutingManagerEnum _currentStrategy = RoutingManagerEnum.AUTO_ROUTE;

  // static const PageNameEnum _defaultStartRoute = PageNameEnum.COMMENT;
  static const PageNameEnum _defaultStartRoute = PageNameEnum.HOME;

  const RouteDatasource({
    RoutingManagerEnum? routingStrategy,
    PageNameEnum? startRoute,
  }) : _startRoute = startRoute ?? _defaultStartRoute;

  /// Gets the start route
  String getStartRoute() {
    return getPageName(_startRoute);
  }

  /// Gets the current routing strategy
  static RoutingManagerEnum get currentStrategy => _currentStrategy;

  /// Checks if the current routing strategy is AutoRoute
  static bool get isAutoRoute => _currentStrategy == RoutingManagerEnum.AUTO_ROUTE;
}
