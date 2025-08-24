import 'package:app_config/di/di_app_config.dart';
import 'package:cc_library/extension/logger.dart';

import '../box/app_track_log/cc_app_track_log.dart';

extension AppTrackLogExtension on CcAppTrackLog {
  List<String>? initMsgIfNull() {
    var list = appConfigLocator<CcAppTrackLog>().msg;
    try {
      list ??= [];
    } catch (e) {
      'AppTrackLogExtension : e'.Log();
    }

    appConfigLocator<CcAppTrackLog>().msg = list;

    return list;
  }
}
