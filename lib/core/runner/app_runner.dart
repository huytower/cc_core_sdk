import 'package:app_config/config/app_config/cc_app_config.dart';
import 'package:app_config/config/device_info/cc_device_info.dart';
import 'package:flutter/material.dart';
import 'package:widget/export/cc_ktx_export.dart';

import '../common/extensions/tracking_log_extension.dart';
import '../datasource/route_datasource.dart';
import '../di/inject/app_inject.dart';
import '../navigate/config/auto_route/app_router.dart';
import '../navigate/config/getx/routing_strategy.dart';
import 'app_runner_impl.dart';

class AppRunner extends StatefulWidget {
  const AppRunner({Key? key}) : super(key: key);

  @override
  State<AppRunner> createState() => AppRunnerState();
}

class AppRunnerState extends State<AppRunner> with AppRunnerImpl {
  // make sure you don't initiate your router
  // inside of the build function.
  final _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();

    'API Environment = ${CcAppConfig.environment}'.Log();
    'Routing Management = ${RouteDatasource.currentStrategy}'.Log();

    onInitState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceInfo = getIt<CcDeviceInfo>();

    deviceInfo
      ..deviceHeight = MediaQuery.of(context).size.height
      ..deviceWidth = MediaQuery.of(context).size.width;

    if (deviceInfo.deviceHeight == null || deviceInfo.deviceWidth == null) {
      'Error : somehow it can not get device resolution'.Log().addAppTrackingLog();

      return const SizedBox();
    }

    return buildBody();
  }

  /// Builds the main app widget according to the selected navigate strategy.
  /// Delegates to [buildAppByRoutingManager] in routing_strategy.dart for functional clarity.
  Widget buildBody() {
    return buildAppByRoutingManager(RouteDatasource.currentStrategy);
  }

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }
}
