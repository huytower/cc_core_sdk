import 'dart:developer' as developer;

import 'package:cc_sdk/core/config/cc_feature_flags.dart';
import 'package:cc_sdk/core/extensions/common/cc_when_expression.dart';
import 'package:cc_sdk/core/serialization/gson/cc_gson.dart';
import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';

/// Debug logging extension for any value.
///
/// Example: `'message'.log()` or `model.log('payload')`.
extension CcLoggerExtension<T> on T {
  // ignore: non_constant_identifier_names
  /// Logs [this] to the console (debug builds) or developer log (large strings).
  ///
  /// Kept as [Log] for backward compatibility with existing call sites.
  T Log([
    String tag = '',
    bool isLargeString = false,
    String tagName = 'logger:~~~/',
  ]) {
    if (!CcFeatureFlags.isEnableLogger) return this;

    final content = ccWhen(
      conditions: {
        this is Object: () {
          try {
            return ccGson.encode(this);
          } catch (e) {
            return '[Serialization Error] $e | $this';
          }
        },
        this is String: () => toString(),
      },
      orElse: toString(),
    );

    ccWhen(
      conditions: {
        isLargeString: () {
          developer.log(
            '$content\n====================================================',
            name: tag.isEmpty ? 'large string' : '$tagName',
          );
        },
      },
      orElse: () {
        if (!kDebugMode) return;
        final tagDisplay = tag.isNotEmpty ? '[$tag] ' : '';
        final message = tag.isNotEmpty
            ? '$tagDisplay$content'
            : '$content';
        developer.log(
          message,
          name: tag.isEmpty ? tagName.trim() : tag,
        );
      },
    );

    return this;
  }
}
