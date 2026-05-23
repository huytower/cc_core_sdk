import 'package:cc_sdk/core/extensions/export_extensions.dart';

import '../../data/datasource/local/box/app_track_log/cc_app_track_log.dart';
import '../di/di.dart';

extension AppTrackLogExtension on CcAppTrackLog {
  List<String>? initMsgIfNull() {
    var list = getIt<CcAppTrackLog>().msg;
    try {
      list ??= [];
    } catch (e) {
      'AppTrackLogExtension : e'.Log();
    }

    getIt<CcAppTrackLog>().msg = list;

    return list;
  }
}
