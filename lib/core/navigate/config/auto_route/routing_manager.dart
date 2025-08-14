import 'package:auto_route/auto_route.dart';

import '../../enum/page_name_enum.dart';
import 'routing_manager.gr.dart';
import 'package:mobile_flutter_template/presentation/sample_code/features_counter_page/features_counter_page.dart';

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
          path: getPageNameInternal(PageNameInternalEnum.BLOC_SIMPLE),
        ),
        AutoRoute(
          page: AdvanceBlocRoute.page,
          path: getPageNameInternal(PageNameInternalEnum.BLOC_ADVANCE),
        ),
        AutoRoute(
          page: GetViewRoute.page,
          path: getPageNameInternal(PageNameInternalEnum.GETX_SIMPLE),
        ),
        AutoRoute(
          page: GetViewV2Route.page,
          path: getPageNameInternal(PageNameInternalEnum.GETX_SIMPLE_V2),
        ),
        AutoRoute(
          page: FeaturesCounterRoute.page,
          path: getPageNameInternal(PageNameInternalEnum.FEATURES_COUNTER),
        ),
      ];
}
