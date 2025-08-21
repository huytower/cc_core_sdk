import 'package:app_config/config/app_config/cc_app_config.dart';
import 'package:flutter/material.dart';
import 'package:widget/export/cc_ktx_export.dart';

import '../common/extensions/tracking_log_extension.dart';
import '../datasource/route_datasource.dart';
import '../datasource/route_strategy.dart';
import '../di/inject/app_inject.dart';
import '../initializers/device_initializer.dart';
import '../managers/hive_manager.dart';

class AppRunner extends StatefulWidget {
  const AppRunner({Key? key}) : super(key: key);

  @override
  State<AppRunner> createState() => AppRunnerState();
}

class AppRunnerState extends State<AppRunner> {
  late final DeviceInitializer _deviceInitializer;
  late final HiveManager _hiveManager;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
    _logEnvironmentInfo();
    _initializeDevice();
  }

  void _initializeDependencies() {
    _deviceInitializer = getIt<DeviceInitializer>();
    _hiveManager = getIt<HiveManager>();
  }

  void _logEnvironmentInfo() {
    'API Environment = ${CcAppConfig.environment}'.Log();
    'Routing Management = ${RouteDatasource.currentStrategy}'.Log();
  }

  Future<void> _initializeDevice() => _deviceInitializer.initialize();

  @override
  Widget build(BuildContext context) {
    _updateDeviceDimensions(context);

    if (!_deviceInitializer.hasValidDimensions()) {
      return _buildErrorWidget('Error: Unable to get device resolution');
    }

    return buildBody();
  }

  /// Builds the main app widget according to the selected navigate strategy.
  /// Delegates to [buildAppByRoutingManager] in route_strategy.dart for functional clarity.
  Widget buildBody() {
    return buildAppByRoutingManager(RouteDatasource.currentStrategy);
  }

  void _updateDeviceDimensions(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _deviceInitializer.updateDimensions(
      mediaQuery.size.height,
      mediaQuery.size.width,
    );
  }

  Widget _buildErrorWidget(String message) {
    message.Log().addAppTrackingLog();
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hiveManager.closeBoxes();
    super.dispose();
  }
}
