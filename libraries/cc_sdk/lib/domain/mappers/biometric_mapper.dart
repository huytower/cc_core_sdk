import '../entities/biometric_auth_result_entity.dart';
import '../models/biometric_auth_result.dart';

/// Mapper class for converting between [BiometricAuthResult] and [BiometricAuthResultEntity]
class BiometricMapper {
  /// Converts a [BiometricAuthResultEntity] to a [BiometricAuthResult] domain model
  static BiometricAuthResult toDomain(BiometricAuthResultEntity entity) {
    return entity.isAuthenticated
        ? BiometricAuthResult.success(
            authType: entity.authType,
          )
        : BiometricAuthResult.failure(
            errorMessage: entity.errorMessage ?? '',
            authType: entity.authType,
          );
  }

  /// Converts a [BiometricAuthResult] domain model to a [BiometricAuthResultEntity]
  static BiometricAuthResultEntity toEntity(BiometricAuthResult model) {
    return BiometricAuthResultEntity(
      isAuthenticated: model.isAuthenticated,
      errorMessage: model.errorMessage,
      authType: model.authType,
    );
  }
}
