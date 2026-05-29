import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../data/datasource/route_datasource.dart';

void navigateFromSplash(BuildContext context) {
  const routeDatasource = RouteDatasource();
  final startRoute = routeDatasource.getStartRoute();
  context.router.replacePath(startRoute);
}
