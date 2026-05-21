import 'package:cc_sdk/core/constants/cc_constants.dart';
import 'package:collection/collection.dart';
import 'package:dartx/dartx.dart';
import 'package:intl/intl.dart';

// Re-export dartx so consumers get its extensions (isNullOrEmpty, capitalize,
// isNullOrBlank, firstOrNull, etc.) without an extra import.
export 'package:dartx/dartx.dart';

// =============================================================================
// STRING EXTENSIONS
// =============================================================================

/// Nullable [String] helpers beyond what `dartx` provides.
extension CcNullableStringExtension on String? {
  /// Returns `''` when the value is `null`.
  String orEmpty() => this ?? '';
}

/// Project-specific [String] extensions.
extension CcStringExtension on String {
  /// Broad "effectively empty" check — `true` for blank, `"null"`, `"{}"`,
  /// `"false"`, and `"0"`.
  bool get isEffectivelyEmpty {
    final trimmed = replaceAll(' ', '');
    return ['', 'null', '{}', 'false', '0'].contains(trimmed);
  }

  /// Truncates to [cutoff] characters and appends `'...'`.
  String truncateWithEllipsis({required int cutoff}) {
    return (length <= cutoff) ? this : '${substring(0, cutoff)}...';
  }

  /// Lowercases the first character (counterpart to dartx `capitalize()`).
  String lowerFirst() {
    if (isEmpty) return '';
    return '${this[0].toLowerCase()}${substring(1)}';
  }
}

// =============================================================================
// INT EXTENSIONS
// =============================================================================

/// Nullable [int] helpers.
extension CcNullableIntExtension on int? {
  /// `true` when non-null and greater than zero.
  bool get isNotNullAndNotZero => this != null && this! > 0;

  /// `true` when `null` or less-than-or-equal to zero.
  bool get isNullOrZero => this == null || this! <= 0;

  /// Converts epoch milliseconds to [DateTime], returning `null` when value
  /// is `null`.
  DateTime? toDateTimeFromMillisecondsSinceEpoch() {
    if (this == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(this!);
  }
}

// =============================================================================
// DATETIME EXTENSIONS
// =============================================================================

/// Project-specific [DateTime] helpers for formatting, UTC offset, and
/// start-/end-of-day computation.
extension CcDateTimeExtension on DateTime {
  /// Formats using [pattern] (defaults to [CcConstantsDateTime.datetimeFormatPattern]).
  String ctmToString({String? pattern}) {
    final fmt = (pattern == null || pattern.isNullOrEmpty)
        ? CcConstantsDateTime.datetimeFormatPattern
        : pattern;
    return DateFormat(fmt).format(toLocalUtc());
  }

  /// Returns the date adjusted to local UTC (currently a no-op placeholder).
  DateTime toLocalUtc({String pattern = ''}) => add(Duration.zero);
}

// =============================================================================
// LIST EXTENSIONS
// =============================================================================

/// Nullable [List] helpers for common collection operations.
extension CcNullableListExtension on List? {
  /// Extracts a single field from each element via [f].
  List<T?> pluck<T>(Function f) {
    if (isNullOrEmpty) return [];
    return [for (final item in this!) f(item) as T?];
  }

  /// Returns the element with the maximum value produced by [f].
  T? ctmGetMax<T>({required Comparable Function(dynamic) f}) {
    if (isNullOrEmpty) return null;
    return this!.reduce((a, b) => f(a).compareTo(f(b)) >= 0 ? a : b) as T?;
  }

  /// Returns the first element matching [f], or the very first element if [f]
  /// is omitted. Returns `null` when the list is null/empty.
  T? ctmFirstOrDefault<T>({bool Function(dynamic)? f}) {
    if (isNullOrEmpty) return null;
    if (f != null) return this!.firstWhereOrNull((x) => f(x)) as T?;
    return this!.first as T?;
  }

  /// Sums elements (or a field extracted by [f]).
  dynamic ctmSum({Function? f, dynamic defaultValue = 0}) {
    if (isNullOrEmpty) return defaultValue;
    var rs = defaultValue;
    for (final item in this!) {
      rs += f != null ? f(item) : item;
    }
    return rs;
  }

  /// Returns `true` when at least one element matches [f] (or the list is
  /// non-empty when [f] is omitted).
  bool ctmAny({bool Function(dynamic)? f}) {
    if (isNullOrEmpty) return false;
    if (f != null) return ctmFirstOrDefault(f: f) != null;
    return true;
  }

  /// `true` when `null` or `.isEmpty`.
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

// =============================================================================
// DOUBLE EXTENSIONS
// =============================================================================

/// Nullable [double] helpers.
extension CcNullableDoubleExtension on double? {
  /// `true` when non-null and greater than zero.
  bool get isNotNullAndNotZero => this != null && this! > 0;
}

// =============================================================================
// MAP EXTENSIONS
// =============================================================================

/// Nullable [Map] helpers.
extension CcNullableMapExtension on Map? {
  /// Returns `map[key]` or `null` when the map is null / key is absent.
  dynamic ctmKeyDefault(String key) {
    if (this == null) return null;
    if (this!.containsKey(key)) return this![key];
    return null;
  }
}
