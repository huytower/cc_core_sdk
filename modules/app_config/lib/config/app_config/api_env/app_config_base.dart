abstract class AppConfigBase {
  /// Application version information
  int get versionIOS => 1;
  int get versionAndroid => 1;
  int get versionApi => 0;

  /// Logging configuration
  bool get isLogger;
  bool get isEnableLoggerDio;
  
  /// API Configuration
  String get baseUrl;
  
  /// Timeout in seconds for API requests
  int get apiTimeoutSeconds => 30;
  
  /// Maximum number of retries for failed API requests
  int get maxRetries => 2;
  
  /// Delay between retries in milliseconds
  int get retryDelayMs => 1000;
  
  /// Environment flags
  bool get isEnvDev => false;
  bool get isEnvPro => false;
  
  /// Setters
  set isLogger(bool value) {}
  set isEnableLoggerDio(bool value) {}
  
  /// Validates that all required configuration is present
  /// Throws [StateError] if validation fails
  void validate() {
    if (baseUrl.isEmpty) {
      throw StateError('baseUrl must be configured');
    }
  }
  
  /// Returns a map of common headers for API requests
  Map<String, String> get apiHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-App-Version': versionApi.toString(),
  };
}
