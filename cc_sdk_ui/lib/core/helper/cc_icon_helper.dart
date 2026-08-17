import 'package:flutter/material.dart';

/// Builds an [IconData] from a stored [codePoint].
///
/// Icon codepoints are persisted as ints, so the resulting [IconData] can't be
/// `const`. Centralizing construction keeps the
/// `non_const_argument_for_const_parameter` lint — a false positive for
/// data-driven icons — in a single place, and honours a stored [fontFamily]
/// when present. Release builds must pass `--no-tree-shake-icons`.
// ignore: non_const_argument_for_const_parameter
IconData iconDataFromCode(int codePoint, {String? fontFamily}) {
  return IconData(codePoint, fontFamily: fontFamily ?? 'MaterialIcons');
}
