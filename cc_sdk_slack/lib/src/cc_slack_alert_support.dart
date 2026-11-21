/// Pieces shared by the Slack error alerts (`CcSlackHandler` for Catcher2
/// reports, `CcSlackCrashReporter` for `CcCrashReporter` calls). Internal.
class CcSlackAlertSupport {
  CcSlackAlertSupport._();

  /// Identical alerts within this window are sent once.
  static const Duration throttleWindow = Duration(minutes: 5);

  /// Last send time per alert key, shared by every Slack alert so the same
  /// error reaching both paths is posted once.
  static final Map<String, DateTime> _lastSent = {};

  /// The first line of [error]: the alert's title and throttle key.
  static String headline(Object? error) =>
      (error?.toString() ?? 'Unknown Error').split('\n').first.trim();

  /// Whether [key] was sent less than [throttleWindow] ago.
  static bool isThrottled(String key, {DateTime? now}) {
    final last = _lastSent[key];
    if (last == null) return false;
    return (now ?? DateTime.now()).difference(last) < throttleWindow;
  }

  /// Records that [key] was sent.
  static void markSent(String key, {DateTime? now}) {
    _lastSent[key] = now ?? DateTime.now();
  }

  /// Clears the throttle; for tests.
  static void resetThrottle() => _lastSent.clear();

  /// The first app frame of [stackTrace] (`package:` path and member),
  /// skipping Flutter, Catcher2 and Dart's async machinery.
  static String whereFromStack(String stackTrace) {
    for (final line in stackTrace.split('\n')) {
      final trimmed = line.trim();
      if (!trimmed.contains('package:') ||
          trimmed.contains('package:flutter/') ||
          trimmed.contains('package:catcher_2/')) {
        continue;
      }
      final match = RegExp(
        r'#\d+\s+(.*?)\s+\((package:.*?)\)',
      ).firstMatch(trimmed);
      return match != null ? '${match.group(2)} [${match.group(1)}]' : trimmed;
    }
    return 'Unknown location';
  }

  /// `yyyy-MM-dd hh:mm AM` in local time.
  static String localTimestamp(DateTime time) {
    final local = time.toLocal();
    String two(int n) => n >= 10 ? '$n' : '0$n';
    final amPm = local.hour >= 12 ? 'PM' : 'AM';
    return '${local.year}-${two(local.month)}-${two(local.day)} '
        '${two(local.hour)}:${two(local.minute)} $amPm';
  }
}
