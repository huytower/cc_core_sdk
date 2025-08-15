library splash_init;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/datasource/route_datasource.dart';

void navigateFromSplash(BuildContext context) {
  final routeDatasource = RouteDatasource();
  final startRoute = routeDatasource.getStartRoute();

  bool isSelectStrategyRoute = CcAppRoutingManager.defaultRoutingManager == RouteDatasource.autoRoute;
  if (isSelectStrategyRoute) {
    // For AutoRoute, use replaceNamed to replace the splash screen
    context.router.replacePath(startRoute);
  } else {
    // For GetX, ensure we're using the correct startRoute format
    final getXRoute = startRoute.startsWith('/') ? startRoute.substring(1) : startRoute;
    Get.offAndToNamed(getXRoute);
  }
}
