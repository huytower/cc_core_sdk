import 'package:auto_route/auto_route.dart';

import '../../enum/page_name_by_route_strategy_enum.dart';
import '../../enum/page_name_enum.dart';
import 'app_router.gr.dart';

/// RECOMMEND WAY for navigate management in app
/// - simple
/// - trending
/// - auto-generated code
/// - tracking via page name
/// ...
/// NOTICE : default page name suffix = 'Page', then convert to 'Route',
/// otherwise auto-generated wrong code
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: SimpleCubitRoute.page,
          path: getPageNameByRouteStrategy(PageNameByRouteStrategyEnum.BLOC_SIMPLE),
        ),
        AutoRoute(
          page: AdvanceBlocRoute.page,
          path: getPageNameByRouteStrategy(PageNameByRouteStrategyEnum.BLOC_ADVANCE),
        ),
        AutoRoute(
          page: GetViewRoute.page,
          path: getPageNameByRouteStrategy(PageNameByRouteStrategyEnum.GETX_SIMPLE),
        ),
        AutoRoute(
          page: GetViewV2Route.page,
          path: getPageNameByRouteStrategy(PageNameByRouteStrategyEnum.GETX_SIMPLE_V2),
        ),
        AutoRoute(
          page: FeaturesCounterRoute.page,
          path: getPageName(PageNameEnum.FEATURES_COUNTER),
        ),
        AutoRoute(
          page: HomeRoute.page,
          path: getPageName(PageNameEnum.HOME),
        ),
      ];
}
