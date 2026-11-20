import 'dart:developer' as developer;

import 'package:cc_sdk/src/core/config/cc_feature_flags.dart';
import 'package:cc_sdk/src/core/serialization/gson/cc_gson.dart';
import 'package:flutter/foundation.dart';

/// Debug logging extension for any value.
///
/// Example: `'message'.Log()` or `model.Log('payload')`.
extension CcLoggerExtension<T> on T {
  // ignore: non_constant_identifier_names
  /// Logs [this] and returns it unchanged.
  ///
  /// Nothing happens unless [CcFeatureFlags.isEnableLogger] is on. Regular
  /// logs go out in debug builds only; with [isLargeString] the value is
  /// logged in every build mode, without truncation. Strings are logged as
  /// is, other values as their `ccGson` encoding (or `toString()` if that
  /// fails).
  ///
  /// Kept as [Log] for backward compatibility with existing call sites.
  T Log([
    String tag = '',
    bool isLargeString = false,
    String tagName = 'logger:~~~/',
  ]) {
    if (!CcFeatureFlags.isEnableLogger) return this;

    if (isLargeString) {
      developer.log(
        '${_ccLogContent(this)}\n'
        '====================================================',
        name: tag.isEmpty ? 'large string' : tagName,
      );
      return this;
    }

    // Serialize only when the line is actually written.
    if (!kDebugMode) return this;
    final content = _ccLogContent(this);
    developer.log(
      tag.isEmpty ? content : '[$tag] $content',
      name: tag.isEmpty ? tagName.trim() : tag,
    );
    return this;
  }
}

/// The text `.Log()` writes for [value].
String _ccLogContent(Object? value) {
  if (value == null || value is String) return '$value';
  try {
    return ccGson.encode(value);
  } catch (e) {
    return '[Serialization Error] $e | $value';
  }
}
