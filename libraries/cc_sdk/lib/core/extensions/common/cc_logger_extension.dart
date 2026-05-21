import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:stack_trace/stack_trace.dart';

import '../../config/library_config.dart';
import '../../enum/symbol_logger.dart';
import '../../serialization/gson/gson.dart';
import 'when_expression.dart';

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
    bool showTimestamp = true,
  ]) {
    final trace = Trace.current(1).terse.frames[0];
    final now = DateTime.now().toIso8601String();
    const reset = '\x1B[0m';
    const green = '\x1B[32m';
    const red = '\x1B[31m';
    const blue = '\x1B[34m';

    final library = path.prettyUri(trace.uri);
    final url = '$library ${trace.line}:${trace.column} ⇙';

    final content = when(
      conditions: {
        this is Object: () {
          try {
            return gson.encode(this);
          } catch (e) {
            return '[Serialization Error] $e | $this';
          }
        },
        this is String: () => toString(),
      },
      orElse: toString(),
    );

    when(
      conditions: {
        isLargeString: () {
          developer.log(
            '$content\n====================================================',
            name: tag.isEmpty ? 'large string' : '$tagName $url',
          );
        },
      },
      orElse: () {
        final tagDisplay = tag.isNotEmpty ? '[$tag] ' : '';
        final prefix =
            showTimestamp ? '\n$now $tagName $url' : '\n$tagName $url';
        if (!kDebugMode) return;
        if (tag.isNotEmpty) {
          print('$prefix\n💬 $tagDisplay$content');
        } else {
          print('$prefix\n💬 $content');
        }
      },
    );

    if (!isLargeString) {
      when(
        variable: LibraryConfig.symbolLogger,
        conditions: {
          SymbolLogger.INFO: () {
            if (kDebugMode) {
              print('\n$blue━━━━━━━━━━ ℹ️ INFO ━━━━━━━━━━$reset');
            }
          },
          SymbolLogger.ERROR: () {
            if (kDebugMode) {
              print('\n$red━━━━━━━━━━ ❌ ERROR ━━━━━━━━━━$reset');
            }
          },
          SymbolLogger.WARNING: () {
            if (kDebugMode) {
              print('\n$green━━━━━━━━━━ 😃 WARNING ━━━━━━━━━━$reset');
            }
          },
        },
        orElse: () {
          if (kDebugMode) {
            print('\n---------------------------------------------------');
          }
        },
      );
    }
    return this;
  }
}
