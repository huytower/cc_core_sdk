import 'cc_app_attestation.dart';

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

