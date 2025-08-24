import 'package:app_config/box/cc_hive_box.dart';
import 'package:hive/hive.dart';

/// Manages Hive database operations
class HiveManager {
  /// Closes all Hive boxes
  Future<void> closeBoxes() async {
    await Future.wait([
      Hive.box(CcHiveBox.APP_BOX_NAME).close(),
      Hive.box(CcHiveBox.DEVICE_BOX_NAME).close(),
      Hive.box(CcHiveBox.TRACK_LOG_BOX_NAME).close(),
    ]);
  }
}
