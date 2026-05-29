/// Define all pages in app, serve for :
/// - Routing
/// - GA4

/// PRJ. PAGE
enum PageNameEnum {
  DASHBOARD,
  SPLASH,
  SETTING,
  LOGIN,
  LOGOUT,
  PROFILE,
  UPDATE_VERSION,
  WEB,
  COMMENT,
  FEATURES_COUNTER,
}

String getPageName(PageNameEnum pageName) => '/${pageName.name.toLowerCase()}';
