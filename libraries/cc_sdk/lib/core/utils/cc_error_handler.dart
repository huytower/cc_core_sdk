class CcErrorHandler {
  static void handleError(Object error, [StackTrace? stackTrace]) {
    // You can expand this to log to a service, show a dialog, etc.
    // For now, just print the error in debug mode.
    assert(() {
      // ignore: avoid_print
      print('Error: '
          '$error'
          '${stackTrace != null ? '\nStackTrace: $stackTrace' : ''}');
      return true;
    }());
  }
}
