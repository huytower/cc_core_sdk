import 'package:cc_sdk/core/config/cc_app_track_info.dart';
import 'package:cc_sdk/core/crash_reporting/cc_crash_log_paths.dart';
import 'package:cc_sdk/core/utils/common/cc_device_info_service.dart';
import 'package:get_it/get_it.dart';
import 'package:cc_sdk_ui/widgets/divider_line/cc_divider.dart';
import 'package:cc_sdk_ui/widgets/icon/ic_copy.dart';
import 'package:cc_sdk_ui/widgets/space/cc_space.dart';
import 'package:cc_sdk_ui/widgets/text/app_name_widget.dart';
import 'package:cc_sdk_ui/widgets/text/cc_text.dart';
import 'package:flutter/material.dart';

/// Bottom sheet that shows the on-device [catcher_2](https://pub.dev/packages/catcher_2) log file.
///
/// Open via long-press on the app root ([CrashLogDevOverlay]) in debug builds.
@immutable
class CrashLogViewerPage extends StatefulWidget {
  const CrashLogViewerPage({super.key});

  @override
  State<CrashLogViewerPage> createState() => _CrashLogViewerPageState();
}

class _CrashLogViewerPageState extends State<CrashLogViewerPage> {
  String _logContent = '';
  String _appInfo = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final version = await GetIt.instance<CcDeviceInfoService>().getAppVersion();
    final logs = await CcCrashLogPaths.readLogContent();
    if (!mounted) return;
    setState(() {
      _appInfo = '${CcAppTrackName.appName}/$version';
      _logContent = logs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CcSpaceSM(),
        CcCopyWidget(
          title: _appInfo,
          child: AppNameWidget(_appInfo, fontSize: 12),
        ),
        const CcSpaceSM(),
        const CcDividerLine(color: Colors.grey),
        const CcSpaceSM(),
        CcText(
          'Long-press anywhere on the app to open this screen (debug).',
          color: Colors.grey,
          fontSize: 11,
          textAlign: TextAlign.center,
          align: Alignment.center,
        ),
        const CcSpaceSM(),
        Flexible(
          fit: FlexFit.loose,
          child: _buildLogBody(),
        ),
        const CcSpaceSM(),
        const CcDividerLine(color: Colors.grey),
        const CcSpaceSM(),
        CcCopyWidget(
          title: CcCrashLogPaths.logFileName,
          child: CcText(
            CcCrashLogPaths.logFileName,
            color: Colors.grey,
            fontSize: 11,
            textAlign: TextAlign.center,
            align: Alignment.center,
          ),
        ),
        const CcSpaceFooter(),
      ],
    );
  }

  Widget _buildLogBody() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_logContent.trim().isEmpty) {
      return const CcText(
        'No crash logs yet.\nTrigger an error or restart after a crash.',
        color: Colors.grey,
        fontSize: 12,
        textAlign: TextAlign.center,
        align: Alignment.center,
      );
    }
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.5,
      child: CcCopyWidget(
        title: _logContent,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SelectableText(
            _logContent,
            style: const TextStyle(fontSize: 11, height: 1.4),
          ),
        ),
      ),
    );
  }
}
