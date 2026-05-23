import 'package:flutter/material.dart';

import '../../data/datasource/route_strategy.dart';
import '../di/inject/inject.dart';

class AppRunner extends StatefulWidget {
  const AppRunner({super.key});

  @override
  State<AppRunner> createState() => AppRunnerState();
}

class AppRunnerState extends State<AppRunner> {
  late final RoutingStrategy _routingStrategy;

  @override
  void initState() {
    super.initState();
    _routingStrategy = getIt<RoutingStrategy>();
  }

  @override
  Widget build(BuildContext context) {
    return _routingStrategy.buildApp();
  }

  @override
  void dispose() {
    getIt.reset();
    super.dispose();
  }
}
