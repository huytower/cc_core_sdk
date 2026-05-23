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

  @override
  void initState() {
    super.initState();
    _hiveManager = getIt<HiveManager>();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  /// Builds the main app ui according to the selected navigate strategy.
  /// Delegates to [buildAppByRoutingManager] in route_strategy.dart for functional clarity.
  Widget buildBody() {
    return buildAppByRoutingManager(RouteDatasource.currentStrategy);
  }

  @override
  void dispose() {
    _hiveManager.closeBoxes();
    super.dispose();
  }
}
