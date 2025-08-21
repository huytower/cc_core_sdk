library splash_init;

import 'package:app_config/enum/routing_manager_enum.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/datasource/route_datasource.dart';

void navigateFromSplash(BuildContext context) {
  const routeDatasource = RouteDatasource();
  final startRoute = routeDatasource.getStartRoute();

  // Handle routing based on the current strategy
  switch (RouteDatasource.currentStrategy) {
    case RoutingManagerEnum.AUTO_ROUTE:
      // For AutoRoute, use replacePath to replace the splash screen
      context.router.replacePath(startRoute);
      break;
    case RoutingManagerEnum.GETX:
      // For GetX, ensure we're using the correct startRoute format
      final getXRoute = startRoute.startsWith('/') ? startRoute.substring(1) : startRoute;
      Get.offAndToNamed(getXRoute);
      break;
  }
}
