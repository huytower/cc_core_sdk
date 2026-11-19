/// App attestation: proves to the backend that requests come from a genuine
/// install of this app, independent of any vendor.
///
/// The SDK core only defines this contract. An implementation comes from a
/// capability package (e.g. `CcFirebaseAppAttestation` in `cc_sdk_firebase`,
/// Firebase App Check), registered in DI as `CcAppAttestation`; apps without
/// attestation can register [CcNoopAppAttestation].
///
/// ```dart
/// unawaited(getIt<CcAppAttestation>().activate());
/// ```
abstract interface class CcAppAttestation {
  /// Starts attestation. Safe to call more than once; later calls no-op.
  /// Throws if the provider cannot be activated.
  Future<void> activate();

  /// Short, human-readable state for diagnostics (e.g. crash reports):
  /// never throws.
  Future<String> statusDescription();

  /// The current attestation token (empty if none); [forceRefresh] asks the
  /// provider for a new one. Throws if the provider fails.
  Future<String> getToken({bool forceRefresh = false});

  /// Turns automatic token refresh on or off. Throws if the provider fails.
  Future<void> setTokenAutoRefresh(bool enabled);
}

/// [CcAppAttestation] that attests nothing: for tests and apps without it.
class CcNoopAppAttestation implements CcAppAttestation {
  const CcNoopAppAttestation();

  @override
  Future<void> activate() async {}

  @override
  Future<String> statusDescription() async => 'Disabled';

  @override
  Future<String> getToken({bool forceRefresh = false}) async => '';

  @override
  Future<void> setTokenAutoRefresh(bool enabled) async {}
}
