import 'package:app_config/box/cc_hive_box.dart';
import 'package:hive/hive.dart';

/// Manages Hive database operations
class HiveManager {
  /// Closes all Hive boxes
  Future<void> closeBoxes() async {
    await Future.wait([
      Hive.box(CcHiveBox.application_box_name).close(),
      Hive.box(CcHiveBox.device_info_box_name).close(),
      Hive.box(CcHiveBox.app_track_log_box_name).close(),
    ]);
  }
}
