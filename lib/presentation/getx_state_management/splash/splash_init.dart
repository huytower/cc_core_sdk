import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/navigation/route_names.dart';

void navigateFromSplash(BuildContext context) {
  // Always navigate to MainNavigationRoute as the main shell
  // The AUTO_ROUTE_START value controls what content shows inside it
  context.router.replacePath(AppRoute.mainNavigation.path);
}
