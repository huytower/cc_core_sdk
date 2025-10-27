import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:stack_trace/stack_trace.dart';

import '../../config/library_config.dart';
import '../../constants/enum/symbol_logger.dart';
import '../../serialization/gson/gson.dart';
import '../common/when_expression.dart';

extension TypeExtension<T> on T {
  /// LOG EXTENSION
  ///
  /// Example : <T>.Log()
  ///
  ///[Log model]__________________________________________________________________
  ///  Test model = Test(value_1: "value_1", value_2: "value_2");
  ///  model.Log("get Content model :..")
  ///
  ///  Result => get Content model :.. {"value_1":"value_1","value_2":"value_2"}
  ///_____________________________________________________________________________
  ///
  ///
  /// test comment.
  /// extension any with logcat.
// ignore: non_constant_identifier_names
  T Log(
      [String tag = "",
      bool isLargeString = false,
      String tagName = "logger:~~~/",
      bool showTimestamp = true]) {
    Frame trace = Trace.current(1).terse.frames[0];

    final now = DateTime.now().toIso8601String();
    const String reset = '\x1B[0m';
    const String green = '\x1B[32m';
    const String red = '\x1B[31m';
    const String blue = '\x1B[34m';
    const String yellow = '\x1B[33m';

    var library = path.prettyUri(trace.uri);
    var line = trace.line;
    var column = trace.column;

    var url = '$library $line:$column ⇙';

    /// check type object...
    String _content = when(
      conditions: {
        this is Object: () {
          try {
            /// parse model obj. to string
            return gson.encode(this);
          } catch (e) {
            return '[Serialization Error] ${e.toString()} | ${toString()}';
          }
        },
        this is String: () {
          return toString();
        },
      },
      orElse: toString(),
    );

    when(
      conditions: {
        /// LONG STRING : show long string
        isLargeString: () {
          developer.log(
            "$_content\n"
            "====================================================",
            name: tag.isEmpty ? "large string" : "$tagName $url",
          );
        },
      },

      /// NORMAL STRING : show normal string
      orElse: () {
        final tagDisplay = tag.isNotEmpty ? '[$tag] ' : '';
        final prefix =
            showTimestamp ? "\n$now $tagName $url" : "\n$tagName $url";
        if (tag.isNotEmpty) {
          if (kDebugMode) {
            print("$prefix\n💬 $tagDisplay$_content");
          }
        } else {
          if (kDebugMode) {
            print("$prefix\n💬 $_content");
          }
        }
      },
    );

    /// NORMAL STRING : attach default tag name
    if (!isLargeString) {
      when(
        variable: LibraryConfig.symbolLogger,
        conditions: {
          SymbolLogger.INFO: () {
            if (kDebugMode) {
              print("\n$blue━━━━━━━━━━ ℹ️ INFO ━━━━━━━━━━$reset");
            }
          },
          SymbolLogger.ERROR: () {
            if (kDebugMode) {
              print("\n$red━━━━━━━━━━ ❌ ERROR ━━━━━━━━━━$reset");
            }
          },
          SymbolLogger.WARNING: () {
            if (kDebugMode) {
              print("\n$green━━━━━━━━━━ 😃 WARNING ━━━━━━━━━━$reset");
            }
          }
        },
        orElse: () {
          if (kDebugMode) {
            print("\n---------------------------------------------------");
          }
        },
      );
    }
    return this;
  }
}
