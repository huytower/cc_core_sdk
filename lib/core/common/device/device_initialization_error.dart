/// An error that occurs during device initialization
class DeviceInitializationError extends Error {
  /// Error message
  final String message;

  /// The original error that caused this error
  final Object? error;

  /// Creates a [DeviceInitializationError]
  DeviceInitializationError(
    this.message, [
    this.error,
  ]);
}
