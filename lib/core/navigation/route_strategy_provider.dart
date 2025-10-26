import 'package:app_config/core/enum/routing_manager_enum.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/route_strategy.dart';

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
///
/// Throws [UnimplementedError] if the routing manager is not supported
Widget buildAppByRoutingManager(RoutingManagerEnum manager) {
  final strategy = RouteStrategyProvider.getStrategy(manager);
  return strategy.build();
}
