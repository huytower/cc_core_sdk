import 'package:flutter/services.dart';

/// String utilities not covered by [dartx](https://pub.dev/packages/dartx).
abstract final class CcStringUtils {
  CcStringUtils._();

  /// Copies [text] to the system clipboard.
  static Future<void> copyToClipboard(String text) =>
      Clipboard.setData(ClipboardData(text: text));
}
