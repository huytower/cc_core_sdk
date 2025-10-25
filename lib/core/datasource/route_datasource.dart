import 'package:app_config/enum/routing_manager_enum.dart';
import '../navigation/enums/page_name_enum.dart';

/// Handles application routing configuration and route resolution
class RouteDatasource {
  // Private constants
  static const RoutingManagerEnum _currentStrategy = RoutingManagerEnum.AUTO_ROUTE;
  static const PageNameEnum _defaultStartRoute = PageNameEnum.HOME;
  
  final PageNameEnum _startRoute;

  const RouteDatasource({
    RoutingManagerEnum? routingStrategy,
    PageNameEnum? startRoute,
  }) : _startRoute = startRoute ?? _defaultStartRoute;

  // Public Getters
  
  /// Gets the start route as a string
  String getStartRoute() => _resolveRouteName(_startRoute);

  /// Gets the current routing strategy
  static RoutingManagerEnum get currentStrategy => _currentStrategy;

  /// Checks if the current routing strategy is AutoRoute
  static bool get isAutoRoute => _isStrategyAutoRoute(_currentStrategy);

  // Private Helpers
  
  /// Resolves the route name from PageNameEnum
  static String _resolveRouteName(PageNameEnum route) {
    return getPageName(route);
  }
  
  /// Checks if the given strategy is AutoRoute
  static bool _isStrategyAutoRoute(RoutingManagerEnum strategy) {
    return strategy == RoutingManagerEnum.AUTO_ROUTE;
  }
  
  /// Validates if the provided route is valid
  static bool _isValidRoute(PageNameEnum? route) {
    return route != null && route.index >= 0 && route.index < PageNameEnum.values.length;
  }
}
