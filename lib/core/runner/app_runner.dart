import 'package:flutter/material.dart';

import '../../data/datasource/route_datasource.dart';
import '../common/managers/hive_manager.dart';
import '../di/inject/inject.dart';
import '../navigation/route_strategy_provider.dart';

class AppRunner extends StatefulWidget {
  const AppRunner({super.key});

  @override
  State<AppRunner> createState() => AppRunnerState();
}

class AppRunnerState extends State<AppRunner> {
  late final HiveManager _hiveManager;
  late final RouteStrategyProvider _routeStrategyProvider;

  @override
  void initState() {
    super.initState();
    _routeStrategyProvider = getIt<RouteStrategyProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return _routeStrategyProvider
        .getStrategy(RouteDatasource.currentStrategy)
        .buildApp();
  }

  @override
  void dispose() {
    _routeStrategyProvider.disposeAll();
    _hiveManager.closeBoxes();
    super.dispose();
  }
}
