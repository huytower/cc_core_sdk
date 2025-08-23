import 'dart:async';

/// A utility class for date and time operations.
class DateTimeUtils {
  /// Converts a [Duration] to a formatted time string (HH:MM:SS or MM:SS).
  /// 
  /// Example:
  /// ```dart
  /// final duration = Duration(hours: 1, minutes: 30, seconds: 15);
  /// final timeString = DateTimeUtils.durationToTimeString(duration);
  /// print(timeString); // '1:30:15'
  /// ```
  static String durationToTimeString(Duration duration) {
    final hours = duration.inHours != 0 ? '${duration.inHours}:' : '';
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(hours.isEmpty ? 1 : 2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    
    return hours.isEmpty ? '$minutes:$seconds' : '$hours$minutes:$seconds';
  }

  /// Converts a time string (HH:MM:SS or MM:SS) to a [Duration].
  /// 
  /// Example:
  /// ```dart
  /// final duration = DateTimeUtils.timeStringToDuration('1:30:15');
  /// print(duration); // 1 hour, 30 minutes, 15 seconds
  /// ```
  /// 
  /// Throws [FormatException] if the input string is not in a valid format.
  static Duration timeStringToDuration(String timeString) {
    final parts = timeString.split(':');
    
    if (parts.isEmpty || parts.length > 3) {
      throw const FormatException('Invalid time string format. Expected HH:MM:SS or MM:SS');
    }

    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    if (parts.length == 3) {
      hours = int.tryParse(parts[0]) ?? 0;
      minutes = int.tryParse(parts[1]) ?? 0;
      seconds = double.tryParse(parts[2])?.round() ?? 0;
    } else if (parts.length == 2) {
      minutes = int.tryParse(parts[0]) ?? 0;
      seconds = double.tryParse(parts[1])?.round() ?? 0;
    } else {
      seconds = double.tryParse(parts[0])?.round() ?? 0;
    }

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  /// Gets the current UTC time in microseconds since epoch.
  static int getUtcNowInTimeStamp() => DateTime.now().microsecondsSinceEpoch;

  /// Converts a [DateTime] to UTC time.
  /// 
  /// [dateTime] - The date time to convert
  /// [pattern] - Optional format pattern (not used in conversion, kept for backward compatibility)
  /// 
  /// Returns the UTC version of the input date time
  static DateTime toUtc(DateTime dateTime, {String pattern = ''}) {
    // If the date is already in UTC, return it as is
    if (dateTime.isUtc) return dateTime;
    
    // Convert local time to UTC
    return dateTime.toUtc();
  }

  /// Converts a local [DateTime] to UTC time.
  /// 
  /// This is an alias for [toUtc] kept for backward compatibility.
  /// Prefer using [toUtc] for new code.
  static DateTime getUTCLocal({required DateTime dtm, String pattern = ''}) => 
      toUtc(dtm, pattern: pattern);
}
