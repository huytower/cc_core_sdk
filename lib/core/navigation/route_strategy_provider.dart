import 'package:app_config/core/enum/routing_manager_enum.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/route_strategy.dart';

/// Returns the main app UI for the given navigate manager.
///
/// Since only AutoRoute is supported now, this always uses [AutoRouteStrategy].
Widget buildAppByRoutingManager(RoutingManagerEnum manager) {
  return AutoRouteStrategy().build();
}
