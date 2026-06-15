import 'package:auto_route/auto_route.dart';

import '../../route_names.dart';
import 'app_router.gr.dart';

/// Centralized router configuration for the application.
///
/// This class uses auto_route for type-safe navigation and route generation.
/// Routes are organized into logical groups for better maintainability.
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: NavigationBar.page,
      initial: true,
      path: AppRoute.mainNavigation.path,
    ),
    AutoRoute(page: SplashRoute.page, path: AppRoute.splash.path),
    AutoRoute(page: CommentRoute.page, path: AppRoute.comment.path),
    AutoRoute(page: CommentDetailRoute.page, path: AppRoute.commentDetail.path),
    AutoRoute(page: SimpleCubitRoute.page, path: ExampleRoute.blocSimple.path),
    AutoRoute(page: AdvanceBlocRoute.page, path: ExampleRoute.blocAdvance.path),
  ];
}
