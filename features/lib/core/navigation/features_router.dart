import 'package:auto_route/auto_route.dart';

import 'features_router.gr.dart';

@AutoRouterConfig()
class FeaturesRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: DashboardRoute.page, path: '/dashboard'),
  ];
}
