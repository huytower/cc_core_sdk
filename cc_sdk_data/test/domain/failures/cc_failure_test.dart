import 'package:cc_sdk_data/export_cc_sdk_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CcFailure', () {
    test('keeps the message and status code', () {
      const failure = CcServerFailure('Server down', statusCode: 503);

      expect(failure.message, 'Server down');
      expect(failure.statusCode, 503);
    });

    test('failures of the same type and message are equal', () {
      expect(const CcNetworkFailure('offline'), const CcNetworkFailure('offline'));
      expect(
        const CcNetworkFailure('offline'),
        isNot(const CcNetworkFailure('timeout')),
      );
    });

    test('failures of different types are not equal', () {
      expect(const CcCacheFailure('x'), isNot(const CcUnknownFailure('x')));
    });

    test('every failure is a CcFailure without a status code by default', () {
      const failures = <CcFailure>[
        CcCacheFailure('m'),
        CcNetworkFailure('m'),
        CcDeviceFailure('m'),
        CcUnauthorizedFailure('m'),
        CcUnknownFailure('m'),
        CcValidationFailure('m'),
      ];

      for (final failure in failures) {
        expect(failure.message, 'm');
        expect(failure.statusCode, isNull);
      }
    });
  });
}
