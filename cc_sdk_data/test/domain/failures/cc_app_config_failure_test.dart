import 'package:cc_sdk_data/export_cc_sdk_data.dart';
import 'package:flutter_test/flutter_test.dart';

String _describe(CcAppConfigFailure failure) => switch (failure) {
  CcMissingConfigFailure() => 'missing',
  CcInvalidConfigFailure() => 'invalid',
  CcSecurityConfigFailure() => 'security',
  CcConfigFailure() => 'generic',
};

void main() {
  group('CcMissingConfigFailure', () {
    const failure = CcMissingConfigFailure('API_URL');

    test('builds a default message from the key', () {
      expect(failure.message, 'Missing required configuration: API_URL');
      expect(failure.key, 'API_URL');
      expect(failure.type, 'CcMissingConfigFailure');
    });

    test('toString names the type and the key', () {
      expect(
        failure.toString(),
        'CcMissingConfigFailure: Missing required configuration: API_URL '
        '(key: API_URL)',
      );
    });

    test('toJson leaves statusCode out when there is none', () {
      expect(failure.toJson(), {
        'type': 'CcMissingConfigFailure',
        'message': 'Missing required configuration: API_URL',
        'key': 'API_URL',
      });
    });
  });

  group('CcInvalidConfigFailure', () {
    const failure = CcInvalidConfigFailure('TIMEOUT', actualValue: -1);

    test('puts the bad value in the message and the JSON', () {
      expect(failure.message, 'Invalid value for configuration "TIMEOUT": -1');
      expect(failure.toJson()['actualValue'], '-1');
    });

    test('compares the actual value too', () {
      expect(
        failure,
        isNot(const CcInvalidConfigFailure('TIMEOUT', actualValue: -2)),
      );
    });
  });

  group('CcSecurityConfigFailure', () {
    test('sensitiveDataExposure is critical', () {
      final failure = CcSecurityConfigFailure.sensitiveDataExposure(
        key: 'SECRET',
      );

      expect(failure.securityRule, 'sensitive_data_exposure');
      expect(failure.severity, 'critical');
      expect(failure.toJson(), containsPair('severity', 'critical'));
    });

    test('insufficientPermissions names the required permission', () {
      final failure = CcSecurityConfigFailure.insufficientPermissions(
        key: 'ADMIN_URL',
        requiredPermission: 'admin',
      );

      expect(failure.securityRule, 'insufficient_permissions');
      expect(failure.message, contains('Required: admin'));
    });
  });

  group('CcConfigFailure', () {
    test('keeps the status code and writes it to JSON', () {
      const failure = CcConfigFailure('Remote config down', statusCode: 500);

      expect(failure.toJson(), containsPair('statusCode', 500));
      expect(failure.toString(), 'CcConfigFailure: Remote config down');
    });
  });

  test('the sealed hierarchy can be matched exhaustively', () {
    expect(_describe(const CcMissingConfigFailure('k')), 'missing');
    expect(
      _describe(const CcInvalidConfigFailure('k', actualValue: 1)),
      'invalid',
    );
    expect(
      _describe(CcSecurityConfigFailure.sensitiveDataExposure(key: 'k')),
      'security',
    );
    expect(_describe(const CcConfigFailure('m')), 'generic');
  });

  test('a config failure is a CcFailure', () {
    expect(const CcMissingConfigFailure('k'), isA<CcFailure>());
  });
}
