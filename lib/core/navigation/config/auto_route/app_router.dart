import 'package:auto_route/auto_route.dart';

import '../../enums/page_name_by_route_strategy_enum.dart';
import '../../enums/page_name_enum.dart';
import 'app_router.gr.dart';

/// Centralized router configuration for the application.
///
/// This class uses auto_route for type-safe navigation and route generation.
/// Routes are organized into logical groups for better maintainability.
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // Core application routes
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: HomeRoute.page, path: getPageName(PageNameEnum.HOME)),
        AutoRoute(
            page: FeaturesCounterRoute.page,
            path: getPageName(PageNameEnum.FEATURES_COUNTER)),

        // Example routes (BLoC pattern)
        ..._buildBlocExampleRoutes(),

        // Example routes (GetX pattern)
        ..._buildGetXExampleRoutes(),
      ];

  // Example Routes (BLoC) ============================================

  /// Returns all BLoC pattern example routes
  List<AutoRoute> _buildBlocExampleRoutes() => [
        AutoRoute(
          page: SimpleCubitRoute.page,
          path: getPageNameByRouteStrategy(
              PageNameByRouteStrategyEnum.BLOC_SIMPLE),
        ),
        AutoRoute(
          page: AdvanceBlocRoute.page,
          path: getPageNameByRouteStrategy(
              PageNameByRouteStrategyEnum.BLOC_ADVANCE),
        ),
      ];

  // Example Routes (GetX) ============================================

  /// Returns all GetX pattern example routes
  List<AutoRoute> _buildGetXExampleRoutes() => [
        AutoRoute(
          page: GetViewRoute.page,
          path: getPageNameByRouteStrategy(
              PageNameByRouteStrategyEnum.GETX_SIMPLE),
        ),
        AutoRoute(
          page: GetViewV2Route.page,
          path: getPageNameByRouteStrategy(
              PageNameByRouteStrategyEnum.GETX_SIMPLE_V2),
        ),
      ];
}
