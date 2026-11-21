import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CcIntExtension.formatShort', () {
    test('keeps numbers below a thousand as they are', () {
      expect(0.formatShort(), '0');
      expect(999.formatShort(), '999');
    });

    test('groups thousands with dots', () {
      expect(1000.formatShort(), '1.000');
      expect(123456.formatShort(), '123.456');
    });

    test('shortens millions and billions with the given units', () {
      expect(2000000.formatShort(), '2 million');
      expect(1500000.formatShort(), '1.5 million');
      expect(3000000000.formatShort(), '3 billion');
      expect(
        2500000.formatShort(millionUnit: 'M', billionUnit: 'B'),
        '2.5 M',
      );
    });
  });

  test('CcServerException names the message and the code', () {
    final exception = CcServerException(message: 'Bad input', code: '422');

    expect(exception.toString(), 'CcServerException: Bad input (code: 422)');
  });
}
