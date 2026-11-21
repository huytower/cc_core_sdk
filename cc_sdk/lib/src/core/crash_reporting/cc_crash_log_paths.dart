import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// On-device crash log file, written by the app's error hook (for example
/// `CcCatcherBootstrap` in `cc_sdk_catcher`) and read by a log viewer.
///
/// The name stays `catcher_crash.log` so logs written by earlier versions
/// remain readable.
abstract final class CcCrashLogPaths {
  CcCrashLogPaths._();

  static const String logFileName = 'catcher_crash.log';

  static File? _cachedFile;

  static Future<File> resolveLogFile() async {
    if (_cachedFile != null) return _cachedFile!;
    final dir = await getApplicationDocumentsDirectory();
    _cachedFile = File(p.join(dir.path, logFileName));
    return _cachedFile!;
  }

  static Future<String> readLogContent() async {
    final file = await resolveLogFile();
    if (!file.existsSync()) return '';
    return file.readAsString();
  }

  static Future<void> clearLogFile() async {
    final file = await resolveLogFile();
    if (file.existsSync()) {
      await file.writeAsString('');
    }
  }
}
