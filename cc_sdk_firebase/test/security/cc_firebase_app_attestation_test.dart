import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_firebase/export_cc_sdk_firebase.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_test/flutter_test.dart';

/// Returns [token] from getToken (or throws when [fail]); counts activate.
class _FakeAppCheck implements FirebaseAppCheck {
  _FakeAppCheck({this.token, this.fail = false});

  final String? token;
  final bool fail;
  int activateCalls = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    // Return the member's real future type, so a failure is the error itself
    // and not a type mismatch.
    if (invocation.memberName == #getToken) {
      return fail
          ? Future<String?>.error(StateError('app check down'))
          : Future<String?>.value(token);
    }
    if (fail) return Future<void>.error(StateError('app check down'));
    if (invocation.memberName == #activate) activateCalls++;
    return Future<void>.value();
  }
}

void main() {
  test('activate runs once', () async {
    final fake = _FakeAppCheck();
    final CcAppAttestation attestation = CcFirebaseAppAttestation(fake);

    await attestation.activate();
    await attestation.activate();

    expect(fake.activateCalls, 1);
  });

  test('statusDescription reflects the token and never throws', () async {
    expect(
      await CcFirebaseAppAttestation(
        _FakeAppCheck(token: 'abc'),
      ).statusDescription(),
      'Verified (Token present)',
    );
    expect(
      await CcFirebaseAppAttestation(_FakeAppCheck()).statusDescription(),
      'Unverified (Token null/empty)',
    );
    expect(
      await CcFirebaseAppAttestation(
        _FakeAppCheck(fail: true),
      ).statusDescription(),
      startsWith('Failed'),
    );
  });

  test('getToken returns empty for a null token', () async {
    expect(await CcFirebaseAppAttestation(_FakeAppCheck()).getToken(), '');
  });
}
