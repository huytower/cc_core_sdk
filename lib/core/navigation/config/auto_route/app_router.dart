import 'package:auto_route/auto_route.dart';

import '../../route_names.dart';
import 'app_router.gr.dart';

/// Centralized router configuration for the application.
///
/// This class uses auto_route for type-safe navigation and route generation.
/// Routes are organized into logical groups for better maintainability.
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: DashboardRoute.page, path: AppRoute.dashboard.path),
    AutoRoute(page: CommentRoute.page, path: AppRoute.comment.path),
    AutoRoute(page: SimpleCubitRoute.page, path: ExampleRoute.blocSimple.path),
    AutoRoute(page: AdvanceBlocRoute.page, path: ExampleRoute.blocAdvance.path),
  ];
}
