part of 'app_config_failure.dart';

/// Thrown or returned when a required configuration value is missing.
class MissingConfigFailure extends AppConfigFailure {
  const MissingConfigFailure(
    String key, {
    String? message,
    String type = 'MissingConfigFailure',
  }) : super(
         message ?? 'Missing required configuration: $key',
         key: key,
         type: type,
       );
}
