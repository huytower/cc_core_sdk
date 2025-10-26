import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../feature_flags.dart';
import 'base.dart';

/// Free tier environment configuration with mock APIs
class HttpFree extends HttpBase {
  /// Create a new Free environment configuration
  HttpFree() : super(
    isLogger: true,
    isEnableLoggerDio: FeatureFlags.isEnableLogger,
  );

  @override
  final String environmentName = 'FREE_FAKE_API';

  @override
  String get baseUrl =>
      dotenv.get('API_URL', fallback: 'https://jsonplaceholder.typicode.com');

  @override
  int get maxRetries => 1; // Fewer retries for free tier

  @override
  int get retryDelayMs => 500; // Shorter delay for free tier

  @override
  bool get isEnvDev => true;

  @override
  bool get isEnvFree => true; // Mark as free tier environment

  @override
  Map<String, String> get apiHeaders => {
        ...super.apiHeaders,
        'X-Environment': environmentName,
        'X-Mock-Data': 'true',
      };
}
