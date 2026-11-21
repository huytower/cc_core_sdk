import 'package:cc_sdk_data/export_cc_sdk_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CcFailure', () {
    test('keeps the message and status code', () {
      const failure = ServerFailure('Server down', statusCode: 503);

      expect(failure.message, 'Server down');
      expect(failure.statusCode, 503);
    });

    test('failures of the same type and message are equal', () {
      expect(const NetworkFailure('offline'), const NetworkFailure('offline'));
      expect(
        const NetworkFailure('offline'),
        isNot(const NetworkFailure('timeout')),
      );
    });

    test('failures of different types are not equal', () {
      expect(const CacheFailure('x'), isNot(const UnknownFailure('x')));
    });

    test('every failure is a CcFailure without a status code by default', () {
      const failures = <CcFailure>[
        CacheFailure('m'),
        NetworkFailure('m'),
        DeviceFailure('m'),
        UnauthorizedFailure('m'),
        UnknownFailure('m'),
        ValidationFailure('m'),
      ];

      for (final failure in failures) {
        expect(failure.message, 'm');
        expect(failure.statusCode, isNull);
      }
    });
  });
}
