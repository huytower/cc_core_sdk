import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/dashboard_bloc.dart';

/// Dashboard Content Widget - Presentation Layer
/// Refactored to follow project guidelines:
/// - Reuses components from cc_sdk_ui
/// - Uses semantic design tokens for colors and typography
/// - Supports multi-screen and orientation via responsive helpers
/// - Implements full localization
class DashboardContent extends StatelessWidget {
  final dynamic dashboardData;
  final bool isRefreshing;
  final bool isUpdating;

  const DashboardContent({
    Key? key,
    required this.dashboardData,
    this.isRefreshing = false,
    this.isUpdating = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CcResponsiveContainer(
          padding: const EdgeInsets.all(CcPaddingParams.SPACE_LG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CcResponsiveFlex(
                  spacing: CcPaddingParams.SPACE_LG,
                  tabletColumns: 2,
                  desktopColumns: 3,
                  children: [
                    _buildInfoCard(context),
                    _buildCounterCard(context),
                    _buildUpdateCard(context),
                  ],
                ),
              ),
              const CcSpaceLG(),
              _buildRefreshButton(context),
            ],
          ),
        ),
        if (isRefreshing)
          const Positioned(
            top: CcPaddingParams.SPACE_LG,
            right: CcPaddingParams.SPACE_LG,
            child: CcLoadingIconWidget(),
          ),
        if (isUpdating)
          const Positioned.fill(child: Center(child: CcLoadingIconWidget())),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(CcPaddingParams.SPACE_LG),
      decoration: BoxDecoration(
        color: context.ccColorScheme.surface,
        borderRadius: CcWidgetHelper.getBorderRoundedLarge(),
        boxShadow: CcWidgetHelper.getBoxShadows(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CcText(
            dashboardData.title,
            textStyle: context.ccTextTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.ccColorScheme.primary,
            ),
          ),
          const CcSpaceSM(),
          CcText(
            dashboardData.description,
            textStyle: context.ccTextTheme.bodyLarge?.copyWith(
              color: context.ccColorScheme.onSurfaceVariant,
            ),
            maxLines: 5,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }

  Widget _buildCounterCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(CcPaddingParams.SPACE_LG),
      decoration: BoxDecoration(
        color: context.ccColorScheme.surface,
        borderRadius: CcWidgetHelper.getBorderRoundedLarge(),
        boxShadow: CcWidgetHelper.getBoxShadows(context),
      ),
      child: Column(
        children: [
          CcText(
            el.tr(CcLocaleKeys.dashboard_item_count),
            textStyle: context.ccTextTheme.titleLarge,
            align: Alignment.center,
          ),
          const CcSpaceLG(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CcDebounce(
                onTap: () {
                  context.read<DashboardBloc>().add(
                    const DecrementItemCountEvent(),
                  );
                },
                child: Icon(
                  Icons.remove_circle_outline,
                  size: 32,
                  color: context.ccColorScheme.error,
                ),
              ),
              const CcSpaceXL(),
              CcText(
                '${dashboardData.itemCount}',
                textStyle: context.ccTextTheme.headlineLarge?.copyWith(
                  color: context.ccColorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const CcSpaceXL(),
              CcDebounce(
                onTap: () {
                  context.read<DashboardBloc>().add(
                    const IncrementItemCountEvent(),
                  );
                },
                child: Icon(
                  Icons.add_circle_outline,
                  size: 32,
                  color: context.ccColorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(CcPaddingParams.SPACE_LG),
      decoration: BoxDecoration(
        color: context.ccColorScheme.surface,
        borderRadius: CcWidgetHelper.getBorderRoundedLarge(),
        boxShadow: CcWidgetHelper.getBoxShadows(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CcText(
            el.tr(CcLocaleKeys.dashboard_last_updated),
            textStyle: context.ccTextTheme.titleLarge,
          ),
          const CcSpaceSM(),
          CcText(
            _formatDateTime(context, dashboardData.lastUpdated),
            textStyle: context.ccTextTheme.bodyMedium?.copyWith(
              color: context.ccColorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    return CcBaseBtn(
      onTap: () {
        context.read<DashboardBloc>().add(const RefreshDashboardDataEvent());
      },
      title: el.tr(CcLocaleKeys.dashboard_refresh_data),
      bgColor: [
        context.ccColorScheme.primary,
        context.ccColorScheme.primary.withOpacity(0.8),
      ],
      textColor: context.ccColorScheme.onPrimary,
    );
  }

  String _formatDateTime(BuildContext context, DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return el.tr(
        difference.inDays == 1
            ? CcLocaleKeys.dashboard_time_day
            : CcLocaleKeys.dashboard_time_days,
        namedArgs: {'count': difference.inDays.toString()},
      );
    }
    if (difference.inHours > 0) {
      return el.tr(
        difference.inHours == 1
            ? CcLocaleKeys.dashboard_time_hour
            : CcLocaleKeys.dashboard_time_hours,
        namedArgs: {'count': difference.inHours.toString()},
      );
    }
    if (difference.inMinutes > 0) {
      return el.tr(
        difference.inMinutes == 1
            ? CcLocaleKeys.dashboard_time_minute
            : CcLocaleKeys.dashboard_time_minutes,
        namedArgs: {'count': difference.inMinutes.toString()},
      );
    }
    return el.tr(CcLocaleKeys.dashboard_time_just_now);
  }
}
