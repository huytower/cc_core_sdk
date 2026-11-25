import 'cc_ai_failure_kind.dart';

class CcAiFailure {
  const CcAiFailure(this.kind, {this.cause});

  final CcAiFailureKind kind;

  /// The underlying error, for logs and crash reports.
  final Object? cause;

  @override
  String toString() => 'CcAiFailure(${kind.name}: $cause)';
}

