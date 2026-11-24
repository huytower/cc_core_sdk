import 'dart:convert';
import 'dart:developer' as developer;

import 'package:cc_sdk/src/core/config/cc_sdk_config.dart';
import 'package:flutter/foundation.dart';

/// Debug logging extension for any value.
///
/// Example: `'message'.Log()` or `model.Log('payload')`.
extension CcLoggerExtension<T> on T {
  // ignore: non_constant_identifier_names
  /// Logs [this] and returns it unchanged.
  ///
  /// Nothing happens unless [CcSdkConfig.enableLogger] is on. Regular
  /// logs go out in debug builds only; with [hasLargeString] the value is
  /// logged in every build mode, without truncation. Maps and lists are
  /// logged as JSON, other values as their `toString()`.
  ///
  /// Kept as [Log] for backward compatibility with existing call sites.
  T Log([
    String tag = '',
    bool hasLargeString = false,
    String tagName = 'logger:~~~/',
  ]) {
    if (!CcSdkConfig.current.enableLogger) return this;

    if (hasLargeString) {
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

/// The text `.Log()` writes for [value]: maps and lists as JSON (any value
/// JSON cannot hold, written with its `toString()`), anything else as its
/// `toString()`.
String _ccLogContent(Object? value) {
  if (value is! Map && value is! Iterable) return '$value';
  try {
    return jsonEncode(
      value is Iterable ? value.toList() : value,
      toEncodable: (Object? nonEncodable) => nonEncodable.toString(),
    );
  } catch (e) {
    return '[Serialization Error] $e | $value';
  }
}
