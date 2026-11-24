import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_phone/export_cc_sdk_phone.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const CcPhoneNumberValidator validator = CcLibPhoneNumberValidator();

  test('accepts a valid Vietnamese mobile number', () {
    expect(validator.hasValidMobile('+84939722577'), isTrue);
    expect(validator.formatInternational('+84939722577'), isNotNull);
  });

  test('tolerates and normalizes a trunk zero after the country code', () {
    expect(validator.hasValidMobile('+840939722577'), isTrue);
    expect(validator.formatInternational('+840939722577'), '+84939722577');
  });

  test('rejects a number too short for its country', () {
    expect(validator.hasValidMobile('+849397'), isFalse);
  });

  test('rejects empty and garbage input', () {
    expect(validator.hasValidMobile(''), isFalse);
    expect(validator.hasValidMobile('not a number'), isFalse);
  });
}
