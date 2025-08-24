import 'package:app_config/box/device_info/cc_device_info.dart';
import 'package:cc_library/widget/divider_line/cc_divider.dart';
import 'package:cc_library/widget/flex/cc_column_start.dart';
import 'package:cc_library/widget/icon/ic_copy.dart';
import 'package:cc_library/widget/space/cc_space.dart';
import 'package:cc_library/widget/text/app_name_widget.dart';
import 'package:cc_library/widget/text/cc_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget/export/cc_ktx_export.dart';

import '../../../../../core/di/inject/inject.dart';
import '../logic/app_track_log_cubit.dart';
import '../logic/app_track_log_state.dart';

/// SHOW APP TRACKING LOG PAGE
///
/// ex.
/// OpenDialog.showBottomSheet(context, AppTrackLogPage(),);
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
        return buildBody(state, cubit);
      },
    );
  }

  Widget buildBody(AppTrackLogState state, AppTrackLogCubit cubit) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CcSpaceSmall(),
          CcCopyWidget(
            title: cubit.appInfo,
            child: AppNameWidget(
              cubit.appInfo,
              fontSize: 12,
            ),
          ),
          const CcSpaceSmall(),
          const CcDividerLine(
            color: Colors.grey,
          ),
          const CcSpaceSmall(),
          Flexible(fit: FlexFit.loose, child: buildLogs(cubit)),
          const CcSpaceSmall(),
          const CcDividerLine(
            color: Colors.grey,
          ),
          const CcSpaceSmall(),
          buildDeviceInfo(state),
          const CcSpaceFooter(),
        ],
      );

  Widget buildDeviceInfo(AppTrackLogState state) => state.deviceModel.deviceInfo.isNotEmpty
      ? CcCopyWidget(
          title: state.deviceModel.deviceInfo,
          child: CcText(
            state.deviceModel.deviceInfo,
            color: Colors.grey,
            fontSize: 12,
            textAlign: TextAlign.center,
            align: Alignment.center,
            maxLines: 10,
          ),
        )
      : const Center(child: CircularProgressIndicator());

  Widget buildLogs(AppTrackLogCubit cubit) {
    'buildLog() : loggingMessages = ${cubit.state.loggingMessages?.length}'.Log();

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
                  return buildLogItem(index, cubit);
                }),
          )
        : const CcText(
            'There is no app tracking logs now',
            color: Colors.grey,
            fontSize: 12,
            textAlign: TextAlign.center,
            align: Alignment.center,
          );
  }

  Widget buildLogItem(int index, AppTrackLogCubit cubit) {
    final messages = cubit.state.loggingMessages;
    if (messages == null || index >= messages.length) {
      return const SizedBox.shrink();
    }

    return CcColStart(children: [
      CcText(
        messages[index],
        color: (index.isEven) ? Colors.blueGrey : Colors.grey,
        fontSize: 12,
        marginLeft: 10,
        marginRight: 10,
        maxLines: 5,
        heightLine: 1.6,
      ),
      const CcSpaceSmallest(),
    ]);
  }
}
