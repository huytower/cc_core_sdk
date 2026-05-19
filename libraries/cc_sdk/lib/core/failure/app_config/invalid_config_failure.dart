part of 'app_config_failure.dart';

/// Thrown or returned when a configuration value is found but is invalid or malformed.
class InvalidConfigFailure extends AppConfigFailure {
  /// The value that failed validation.
  final dynamic actualValue;

  const InvalidConfigFailure(
    String key, {
    required this.actualValue,
    String? message,
    String type = 'InvalidConfigFailure',
  }) : super(
         message ?? 'Invalid value for configuration "$key": $actualValue',
         key: key,
         type: type,
       );

  @override
  List<Object?> get props => [...super.props, actualValue];

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'actualValue': actualValue.toString(),
  };
}
