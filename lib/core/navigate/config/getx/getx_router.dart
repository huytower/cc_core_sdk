import 'package:get/get.dart';

import '../../../../sample_code/getx_simple_page/way_1/getx/get_view_controller.dart';
import '../../../../sample_code/getx_simple_page/way_1/ui/get_view_page.dart';
import '../../../../sample_code/getx_simple_page/way_2/getx/get_view_v2_binding.dart';
import '../../../../sample_code/getx_simple_page/way_2/ui/get_view_v2_view.dart';
import '../../../../screen/getx/comment/get_x/comment_controller.dart';
import '../../../../screen/getx/comment/ui/comment_screen.dart';
import '../../../../screen/getx/splash/splash_page.dart';
import '../../../../screen/getx/web/get_x/web_controller.dart';
import '../../../../screen/getx/web/ui/web_page.dart';
import '../../enum/page_name_by_route_strategy_enum.dart';
import '../../enum/page_name_enum.dart';

/// GETX|BLOC : Routing management
/// Step 3 : declare navigate screen||page
///
class GetxRoutingManager {
  /// Instance
  GetxRoutingManager._private();

  static final GetxRoutingManager instance = GetxRoutingManager._private();

  List<GetPage> getPages() {
    return [
      GetPage(
        name: getPageName(PageNameEnum.SPLASH),
        page: () => const SplashPage(),
      ),
      GetPage(
          name: getPageName(PageNameEnum.WEB),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
          binding: WebBinding(),
          page: () => const WebPage()),

      /// CORE PAGE
      GetPage(
          name: getPageNameByRouteStrategy(PageNameByRouteStrategyEnum.GETX_SIMPLE),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
          binding: GetViewBinding(),
          page: () => GetViewPage()),
      GetPage(
          name: getPageNameByRouteStrategy(PageNameByRouteStrategyEnum.GETX_SIMPLE_V2),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
          binding: GetViewV2Binding(),
          page: () => GetViewV2Page()),
      GetPage(
        name: getPageName(PageNameEnum.COMMENT),
        page: () => const CommentScreen(),
        binding: CommentBinding(),
      ),
    ];
  }
}
