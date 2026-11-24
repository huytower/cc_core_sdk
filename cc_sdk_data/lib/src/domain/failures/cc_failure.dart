import 'package:equatable/equatable.dart';

/// Base class for all Business Failures in the Domain layer.
///
/// Deliberately open (not `sealed`): apps and micro-features add their own
/// failures (e.g. `AuthCancelledFailure`), so a `switch` over failures needs a
/// default branch.
abstract class CcFailure extends Equatable {
  final String message;
  final int? statusCode;

  const CcFailure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class CcServerFailure extends CcFailure {
  const CcServerFailure(String message, {int? statusCode})
    : super(message, statusCode: statusCode);
}

class CcCacheFailure extends CcFailure {
  const CcCacheFailure(String message) : super(message);
}

class CcNetworkFailure extends CcFailure {
  const CcNetworkFailure(String message) : super(message);
}

class CcDeviceFailure extends CcFailure {
  const CcDeviceFailure(String message) : super(message);
}

class CcUnauthorizedFailure extends CcFailure {
  const CcUnauthorizedFailure(String message) : super(message);
}

class CcUnknownFailure extends CcFailure {
  const CcUnknownFailure(String message) : super(message);
}

/// Raised when domain-level input validation fails (e.g. empty name,
/// non-positive amount, invalid date range).
class CcValidationFailure extends CcFailure {
  const CcValidationFailure(String message) : super(message);
}
