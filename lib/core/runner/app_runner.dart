import 'package:flutter/material.dart';

import '../../data/datasource/route_strategy.dart';
import '../common/managers/hive_manager.dart';
import '../di/inject/inject.dart';

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

  Widget buildBody() => AutoRouteStrategy().build();

  @override
  void dispose() {
    _hiveManager.closeBoxes();
    super.dispose();
  }
}
