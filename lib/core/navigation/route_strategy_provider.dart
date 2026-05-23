import 'package:flutter/material.dart';

import '../../data/datasource/route_strategy.dart';
import '../di/inject/inject.dart';

/// Builds the main app widget using the DI-registered [RoutingStrategy].
Widget buildAppByRoutingStrategy() {
  return getIt<RoutingStrategy>().buildApp();
}
