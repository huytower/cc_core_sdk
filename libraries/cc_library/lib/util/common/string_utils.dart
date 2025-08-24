import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

/// A utility class for string operations.
class StringUtils {
  /// Copies the provided text to the clipboard.
  static void copyToClipboard(String text) => Clipboard.setData(ClipboardData(text: text));

  /// Generates an MD5 hash of the input string.
  static String generateMd5(String input) => md5.convert(utf8.encode(input)).toString();

  /// Checks if a string is null, empty, or contains 'null' or '{}'.
  static bool isNullOrEmpty(String? str) {
    if (str == null) return true;
    return str.isEmpty || str.toLowerCase() == 'null' || str == '{}';
  }

  /// Converts the first character of the string to uppercase.
  ///
  /// Returns an empty string if the input is empty.
  static String capitalizeFirst(String pattern) =>
      pattern.isEmpty ? '' : pattern[0].toUpperCase() + pattern.substring(1);

  /// Checks if the string represents a boolean value.
  ///
  /// Returns `true` if the string is 'true' or '1b' (case-insensitive).
  static bool isBoolean(String value) {
    if (value is String) {
      return value.toLowerCase() == 'true' || value.toLowerCase() == '1b';
    }
    return false;
  }
}
