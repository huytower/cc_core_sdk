import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:stack_trace/stack_trace.dart';

import '../config/library_config.dart';
import '../constant/enum/symbol_logger.dart';
import '../src/gson/gson.dart';
import 'kotlin/when_expression.dart';
import 'kotlin_extension.dart';

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
  T Log([String tag = "", bool isLargeString = false, String tagName = "logger:~~~/"]) {
    Frame trace = Trace.current(1).terse.frames[0];

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
            return toString();
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
            "========================================================================================================================================================",
            name: tag.isEmpty ? "large string" : "$tagName $url",
          );
        },
      },

      /// NORMAL STRING : show normal string
      orElse: () {
        if (tag.isNotEmpty) {
          if (kDebugMode) {
            print("$tagName $url\n⋙ $tag $_content");
          }
        } else {
          if (kDebugMode) {
            print("$tagName $url\n⋙ $_content");
          }
        }
      },
    );

    /// NORMAL STRING : attach default tag name
    if (!isLargeString) {
      when(
        variable: LibraryConfig.symbolLogger,
        conditions: {
          SymbolLogger.NEW: () {
            if (kDebugMode) {
              print("\n-------------------𒆴 𒆴 𒆴 𝝢𝚎ᥕ 𒆴 𒆴 𒆴 --------------------------");
            }
          },
          SymbolLogger.HAPPY: () {
            if (kDebugMode) {
              print("\n--------------𒆴 𒆴 𒆴   Happy "
                  "𒆴 𒆴 𒆴 --------------------------------");
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
