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
    AutoRoute(page: HomeRoute.page, path: AppRoute.home.path),
    AutoRoute(page: CommentRoute.page, path: AppRoute.comment.path),
    AutoRoute(
      page: FeaturesCounterRoute.page,
      path: AppRoute.featuresCounter.path,
    ),
    AutoRoute(
      page: SimpleCubitRoute.page,
      path: ExampleRoute.blocSimple.path,
    ),
    AutoRoute(
      page: AdvanceBlocRoute.page,
      path: ExampleRoute.blocAdvance.path,
    ),
    AutoRoute(
      page: GetViewRoute.page,
      path: ExampleRoute.getxSimple.path,
    ),
    AutoRoute(
      page: GetViewV2Route.page,
      path: ExampleRoute.getxSimpleV2.path,
    ),
  ];
}
