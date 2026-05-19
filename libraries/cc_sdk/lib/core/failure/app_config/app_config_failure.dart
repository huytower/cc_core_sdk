import 'package:meta/meta.dart';

import '../failure.dart';

part 'invalid_config_failure.dart';
part 'missing_config_failure.dart';
part 'security_config_failure.dart';

/// Base failure class for configuration-related errors.
///
/// This class extends [Failure] and uses modern Dart 3 sealed class features
/// to allow for exhaustive pattern matching.
@immutable
sealed class AppConfigFailure extends Failure {
  /// The configuration key associated with this error, if any.
  final String? key;

  /// The type of the failure for programmatic handling.
  final String type;

  const AppConfigFailure(
    super.message, {
    this.key,
    this.type = 'AppConfigFailure',
    super.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode, key, type];

  /// Converts the failure to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'key': key,
      if (statusCode != null) 'statusCode': statusCode,
    };
  }

  @override
  String toString() => '$type: $message${key != null ? ' (key: $key)' : ''}';
}

/// Generic configuration failure when a more specific type isn't available.
class ConfigFailure extends AppConfigFailure {
  const ConfigFailure(
    super.message, {
    super.key,
    super.type = 'ConfigFailure',
    super.statusCode,
  });
}
