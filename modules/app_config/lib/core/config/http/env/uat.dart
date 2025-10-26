import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../feature_flags.dart';
import 'base.dart';

/// UAT (User Acceptance Testing) environment configuration
class HttpUat extends HttpBase {
  /// Create a new UAT environment configuration
  HttpUat() : super(
    isLogger: true,
    isEnableLoggerDio: FeatureFlags.isEnableLogger,
  );

  @override
  final String environmentName = 'UAT';

  @override
  String get baseUrl =>
      dotenv.get('API_URL', fallback: 'https://api.uat.yourdomain.com');

  @override
  int get apiTimeoutSeconds => 60; // Longer timeout for UAT

  @override
  int get maxRetries => 3; // More retries for UAT

  @override
  int get retryDelayMs => 2000; // Longer delay between retries for UAT

  @override
  bool get isEnvUat => true; // Mark as UAT environment

  // UAT-specific feature flags
  static const bool enableExperimentalFeatures = true;

  @override
  Map<String, String> get apiHeaders => {
        ...super.apiHeaders,
        'X-Environment': environmentName,
        'X-Debug-Mode': 'true',
        'X-Experimental-Features': enableExperimentalFeatures.toString(),
      };
}
