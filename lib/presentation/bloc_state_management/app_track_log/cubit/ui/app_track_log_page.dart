import 'package:app_config/data/datasource/local/box/device_info/cc_device_info.dart';
import 'package:cc_sdk/core/extensions/export_cc_extensions.dart';
import 'package:cc_sdk_ui/core/config/tokens/cc_typography_params.dart';
import 'package:cc_sdk_ui/core/extensions/cc_context_extension.dart';
import 'package:cc_sdk_ui/widgets/divider_line/cc_divider.dart';
import 'package:cc_sdk_ui/widgets/flex/cc_flex.dart';
import 'package:cc_sdk_ui/widgets/icon/ic_copy.dart';
import 'package:cc_sdk_ui/widgets/space/cc_space.dart';
import 'package:cc_sdk_ui/widgets/text/app_name_widget.dart';
import 'package:cc_sdk_ui/widgets/text/cc_text.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message/cc_locale_keys.dart';
import 'package:theme/data/data_source/color/prj_color.dart';

import '../../../../../core/di/di.dart';
import '../logic/app_track_log_cubit.dart';
import '../logic/app_track_log_state.dart';

/// SHOW APP TRACKING LOG PAGE
///
/// ex.
/// CcDialogHelper.showModalBottomSheet(context, AppTrackLogPage(),);
///
@immutable
class AppTrackLogPage extends StatelessWidget {
  const AppTrackLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppTrackLogCubit>()..initialize(),
      child: const _AppTrackLogView(),
    );
  }
}

class _AppTrackLogView extends StatelessWidget {
  const _AppTrackLogView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppTrackLogCubit, AppTrackLogState>(
      builder: (context, state) {
        final cubit = context.read<AppTrackLogCubit>();
        return buildBody(context, state, cubit);
      },
    );
  }

  /// Build the main body layout
  Widget buildBody(
    BuildContext context,
    AppTrackLogState state,
    AppTrackLogCubit cubit,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CcSpaceSM(),
        _buildAppInfo(context, cubit),
        const CcSpaceSM(),
        CcDividerLine(color: context.ccColorScheme.outline),
        const CcSpaceSM(),
        Flexible(fit: FlexFit.loose, child: buildLogs(context, cubit)),
        const CcSpaceSM(),
        CcDividerLine(color: context.ccColorScheme.outline),
        const CcSpaceSM(),
        buildDeviceInfo(context, state),
        const CcSpaceFooter(),
      ],
    );
  }

  /// Build app info section
  CcCopyWidget _buildAppInfo(BuildContext context, AppTrackLogCubit cubit) {
    return CcCopyWidget(
      title: cubit.appInfo,
      child: AppNameWidget(
        cubit.appInfo,
        fontSize: CcTypographyParams.bodySmall,
      ),
    );
  }

  /// Build device info widget or loading indicator
  Widget buildDeviceInfo(BuildContext context, AppTrackLogState state) {
    if (state.deviceModel.deviceInfo.isNotEmpty) {
      return CcCopyWidget(
        title: state.deviceModel.deviceInfo,
        child: CcText(
          state.deviceModel.deviceInfo,
          textStyle: context.ccTextTheme.bodySmall?.copyWith(
            color: PrjColors.mediumEmphasis,
          ),
          textAlign: TextAlign.center,
          align: Alignment.center,
          maxLines: 10,
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  /// Build logs list or empty state
  Widget buildLogs(BuildContext context, AppTrackLogCubit cubit) {
    'buildLog() : loggingMessages = ${cubit.state.loggingMessages?.length}'
        .Log();

    return cubit.state.loggingMessages?.isNotEmpty == true
        ? _buildLogsList(context, cubit)
        : _buildEmptyState(context);
  }

  /// Build the logs list view
  SizedBox _buildLogsList(BuildContext context, AppTrackLogCubit cubit) {
    return SizedBox(
      width: double.infinity,
      height: getIt<CcDeviceInfo>().deviceHeight! - 250,
      child: ListView.builder(
        itemCount: cubit.state.loggingMessages?.length,
        itemBuilder: (BuildContext context, int index) {
          return buildLogItem(context, index, cubit);
        },
      ),
    );
  }

  /// Build empty state when no logs available
  CcText _buildEmptyState(BuildContext context) {
    return CcText(
      el.tr(CcLocaleKeys.common_no_data),
      textStyle: context.ccTextTheme.bodySmall?.copyWith(
        color: PrjColors.mediumEmphasis,
      ),
      textAlign: TextAlign.center,
      align: Alignment.center,
    );
  }

  /// Build individual log item
  Widget buildLogItem(BuildContext context, int index, AppTrackLogCubit cubit) {
    final messages = cubit.state.loggingMessages;
    if (messages == null || index >= messages.length) {
      return const SizedBox.shrink();
    }

    return CcColStart(
      children: [
        CcText(
          messages[index],
          textStyle: context.ccTextTheme.bodySmall?.copyWith(
            color: (index.isEven)
                ? context.ccColorScheme.secondary
                : PrjColors.body,
            height: 1.6,
          ),
          marginLeft: 10,
          marginRight: 10,
          maxLines: 5,
        ),
        const CcSpaceSM(),
      ],
    );
  }
}
