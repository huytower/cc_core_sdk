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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Widget buildBody(
    BuildContext context,
    AppTrackLogState state,
    AppTrackLogCubit cubit,
  ) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const CcSpaceSM(),
      CcCopyWidget(
        title: cubit.appInfo,
        child: AppNameWidget(
          cubit.appInfo,
          fontSize: CcTypographyParams.bodySmall,
        ),
      ),
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

  Widget buildDeviceInfo(BuildContext context, AppTrackLogState state) =>
      state.deviceModel.deviceInfo.isNotEmpty
      ? CcCopyWidget(
          title: state.deviceModel.deviceInfo,
          child: CcText(
            state.deviceModel.deviceInfo,
            color: PrjColors.mediumEmphasis,
            fontSize: CcTypographyParams.bodySmall,
            textAlign: TextAlign.center,
            align: Alignment.center,
            maxLines: 10,
          ),
        )
      : const Center(child: CircularProgressIndicator());

  Widget buildLogs(BuildContext context, AppTrackLogCubit cubit) {
    'buildLog() : loggingMessages = ${cubit.state.loggingMessages?.length}'
        .Log();

    // cubit.state.loggingMessages?.forEach((element) {
    //   'buildLog() : element = $element'.Log();
    // });

    return cubit.state.loggingMessages?.isNotEmpty == true
        ? SizedBox(
            width: double.infinity,
            height: getIt<CcDeviceInfo>().deviceHeight! - 250,
            child: ListView.builder(
              itemCount: cubit.state.loggingMessages?.length,
              itemBuilder: (BuildContext context, int index) {
                return buildLogItem(context, index, cubit);
              },
            ),
          )
        : CcText(
            'There is no app tracking logs now',
            color: PrjColors.mediumEmphasis,
            fontSize: CcTypographyParams.bodySmall,
            textAlign: TextAlign.center,
            align: Alignment.center,
          );
  }

  Widget buildLogItem(BuildContext context, int index, AppTrackLogCubit cubit) {
    final messages = cubit.state.loggingMessages;
    if (messages == null || index >= messages.length) {
      return const SizedBox.shrink();
    }

    return CcColStart(
      children: [
        CcText(
          messages[index],
          color: (index.isEven)
              ? context.ccColorScheme.secondary
              : PrjColors.body,
          fontSize: CcTypographyParams.bodySmall,
          marginLeft: 10,
          marginRight: 10,
          maxLines: 5,
          heightLine: 1.6,
        ),
        const CcSpaceSM(),
      ],
    );
  }
}
