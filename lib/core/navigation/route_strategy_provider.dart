import 'package:app_config/core/enum/routing_manager_enum.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasource/route_strategy.dart';
import '../di/inject/inject.dart';

/// Resolves the active [RoutingStrategy] for a given [RoutingManagerEnum].
///
/// Both strategy implementations are injected by the DI container so this
/// class has no hard-coded instantiation.
@lazySingleton
class RouteStrategyProvider {
  final Map<RoutingManagerEnum, RoutingStrategy> _strategies;

  RouteStrategyProvider(
    @Named('autoRoute') RoutingStrategy autoRouteStrategy,
    @Named('getX') RoutingStrategy getXStrategy,
  ) : _strategies = {
          RoutingManagerEnum.AUTO_ROUTE: autoRouteStrategy,
          RoutingManagerEnum.GETX: getXStrategy,
        };

  /// Returns the strategy for [manager], falling back to AutoRoute.
  RoutingStrategy getStrategy(RoutingManagerEnum manager) {
    return _strategies[manager] ?? _strategies[RoutingManagerEnum.AUTO_ROUTE]!;
  }

  /// Disposes every registered strategy.
  void disposeAll() {
    for (final strategy in _strategies.values) {
      strategy.dispose();
    }
  }
}

/// Convenience — builds the app widget for the given routing manager.
Widget buildAppByRoutingManager(RoutingManagerEnum manager) {
  final provider = getIt<RouteStrategyProvider>();
  return provider.getStrategy(manager).buildApp();
}
