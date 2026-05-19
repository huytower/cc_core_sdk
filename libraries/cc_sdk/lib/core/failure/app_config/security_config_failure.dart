part of 'app_config_failure.dart';

/// Thrown or returned when there's a security-related configuration issue.
class SecurityConfigFailure extends AppConfigFailure {
  /// The security rule that was violated.
  final String securityRule;

  /// The severity level of the security issue.
  final String severity;

  const SecurityConfigFailure(
    super.message, {
    required String key,
    required this.securityRule,
    this.severity = 'high',
    String type = 'SecurityConfigFailure',
  }) : super(key: key, type: type);

  @override
  List<Object?> get props => [...super.props, securityRule, severity];

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'securityRule': securityRule,
    'severity': severity,
  };

  /// Creates a security failure for sensitive data exposure.
  factory SecurityConfigFailure.sensitiveDataExposure({
    required String key,
    String? message,
  }) => SecurityConfigFailure(
    message ?? 'Sensitive data exposure detected in configuration',
    key: key,
    securityRule: 'sensitive_data_exposure',
    severity: 'critical',
  );

  /// Creates a security failure for insufficient permissions.
  factory SecurityConfigFailure.insufficientPermissions({
    required String key,
    required String requiredPermission,
  }) => SecurityConfigFailure(
    'Insufficient permissions to access configuration. Required: $requiredPermission',
    key: key,
    securityRule: 'insufficient_permissions',
    severity: 'error',
  );
}
