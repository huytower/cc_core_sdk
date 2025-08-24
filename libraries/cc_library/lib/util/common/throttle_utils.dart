import 'dart:async';

/// A utility class for throttling function calls.
class ThrottleUtils {
  /// Prevents multiple rapid calls to a function.
  ///
  /// [lastExecutionTime] - The timestamp of the last execution (should be a reference to a variable)
  /// [throttleDuration] - The minimum duration between allowed executions
  /// [function] - The function to throttle
  ///
  /// Returns `true` if the function was executed, `false` if it was throttled
  static bool throttle(DateTime? lastExecutionTime, Duration throttleDuration, Function() function) {
    final now = DateTime.now();

    if (lastExecutionTime == null || now.difference(lastExecutionTime) >= throttleDuration) {
      function();
      lastExecutionTime = now;
      return true;
    }

    return false;
  }

  /// Creates a throttled version of a function.
  ///
  /// [function] - The function to throttle
  /// [duration] - The throttle duration
  ///
  /// Returns a new function that wraps the original with throttling
  static Function() throttleFunction(Function() function, Duration duration) {
    Timer? _timer;

    return () {
      if (_timer?.isActive ?? false) return;

      _timer = Timer(duration, () {});
      function();
    };
  }
}
