import 'package:auto_route/auto_route.dart';
import 'package:cc_mixin/export_cc_mixin.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/common/managers/splash_manager.dart';
import 'tabs/dashboard_tab_content.dart';
import 'tabs/notification_tab_content.dart';
import 'tabs/profile_tab_content.dart';
import 'tabs/quick_test_tab_content.dart';

/// Main navigation view with curved navigation bar.
@RoutePage()
class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar>
    with AutomaticKeepAliveClientMixin, CcCurvedNavigationMixin {
  // Navigation indices
  static const int _indexDashboard = 0;
  static const int _indexSecondTab = 1;
  static const int _indexProfile = 2;

  // Example state management implementation
  // This can be replaced with your preferred state management approach
  late int _currentIndex;
  late bool _showQuickTestAsSecondTab;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();

    // Initialize with default value immediately
    _currentIndex = 0;

    // Read from dotenv to determine if second tab should be QuickTesting or Notification
    final startRoute = dotenv.maybeGet(
      'AUTO_ROUTE_START',
      fallback: 'DASHBOARD',
    );
    _showQuickTestAsSecondTab = _isQuickTestRoute(startRoute);
    _checkSplash();
  }

  Future<void> _checkSplash() async {
    final shouldShow = await SplashManager.shouldShowSplash();
    setState(() => _showSplash = shouldShow);
  }

  bool _isQuickTestRoute(String? route) {
    return route?.toUpperCase() == QuickTestTabContent.routeName;
  }

  @override
  int get currentIndex => _currentIndex;

  @override
  void setIndex(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  List<CcCurvedNavigationItem> get navigationItems => [
    CcCurvedNavigationItem(
      inactiveIcon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
      label: context.tr(CcLocaleKeys.nav_dashboard),
    ),
    _showQuickTestAsSecondTab
        ? CcCurvedNavigationItem(
            inactiveIcon: Icons.bug_report_outlined,
            activeIcon: Icons.bug_report_rounded,
            label: context.tr(CcLocaleKeys.nav_quick_test),
          )
        : CcCurvedNavigationItem(
            inactiveIcon: Icons.notifications_outlined,
            activeIcon: Icons.notifications_rounded,
            label: context.tr(CcLocaleKeys.nav_notification),
          ),
    CcCurvedNavigationItem(
      inactiveIcon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: context.tr(CcLocaleKeys.nav_profile),
    ),
  ];

  @override
  bool get isEnableAppBar => false;

  @override
  bool get isEnableBottomNavigation => true;

  @override
  PreferredSizeWidget? appBar() => null;

  @override
  Widget? bottomNavigationBar() => buildCurvedNavigationBar();

  @override
  Widget? buildContent() {
    if (_showSplash) {
      return _buildSplashOverlay();
    }
    return _buildContentForIndex(currentIndex);
  }

  Widget _buildSplashOverlay() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContentForIndex(int index) {
    switch (index) {
      case _indexDashboard:
        return const DashboardTabContent();
      case _indexSecondTab:
        return _showQuickTestAsSecondTab
            ? const QuickTestTabContent()
            : const NotificationTabContent();
      case _indexProfile:
        return const ProfileTabContent();
      default:
        return const DashboardTabContent();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(child: body),
      appBar: isEnableAppBar ? appBar() : null,
      bottomNavigationBar: isEnableBottomNavigation
          ? bottomNavigationBar()
          : null,
    );
  }

  Widget get body {
    final content = buildContent() ?? const SizedBox.shrink();
    if (layoutStatus == CcLayoutStatus.success) {
      return FadePageWrapper(child: content);
    }
    // For simplicity, just show content for now
    return FadePageWrapper(child: content);
  }

  CcLayoutStatus get layoutStatus => CcLayoutStatus.success;
}
