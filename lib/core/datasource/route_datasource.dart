import 'package:app_config/enum/routing_manager_enum.dart';

import '../../core/navigate/enum/page_name_enum.dart';

class RouteDatasource {
  // Constants
  static const PageNameInternalEnum _initRoute = PageNameInternalEnum.FEATURES_COUNTER;

  // Public constants for switch cases
  static const RoutingManagerEnum autoRoute = RoutingManagerEnum.AUTO_ROUTE;
  static const RoutingManagerEnum getXRoute = RoutingManagerEnum.GETX;

  // Methods
  String getStartRoute() {
    bool isSelectStrategyRoute = CcAppRoutingManager.defaultRoutingManager == RouteDatasource.autoRoute;
    if (isSelectStrategyRoute) {
      return getPageNameInternal(
          PageNameInternalEnum.FEATURES_COUNTER); // Use the same initial route as defined in AppRouter
    } else {
      return getPageNameInternal(_initRoute); // Use generated route for GetX
    }
  }
}

class CcAppRoutingManager {
  static RoutingManagerEnum defaultRoutingManager = RoutingManagerEnum.AUTO_ROUTE;

  bool get isAutoRoute => defaultRoutingManager == RoutingManagerEnum.AUTO_ROUTE;
}
