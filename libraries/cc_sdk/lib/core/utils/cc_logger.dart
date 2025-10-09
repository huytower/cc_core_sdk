import 'package:flutter/foundation.dart';

class CcLogger {
  static void log(String message, {String? tag}) {
    if (kDebugMode) {
      final logTag = tag != null ? '[$tag] ' : '';
      // ignore: avoid_print
      print('${logTag}${DateTime.now().toIso8601String()} - $message');
    }
  }
}
