import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_phone/export_cc_sdk_phone.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const CcPhoneNumberValidator validator = CcLibPhoneNumberValidator();

  group('formatInternational', () {
    test('returns the compact E.164 form of a valid mobile number', () {
      expect(validator.formatInternational('+84 912-345-678'), '+84912345678');
    });

    test('returns null for input that is not a valid mobile number', () {
      expect(validator.formatInternational('+84912'), isNull);
      expect(validator.formatInternational(''), isNull);
      expect(validator.formatInternational('not a number'), isNull);
    });
  });

  test('is stricter than the dependency-free basic validator', () {
    // Well-formed E.164, but too short for a Vietnamese mobile number.
    const number = '+84123456';

    expect(const CcBasicPhoneNumberValidator().isValidMobile(number), isTrue);
    expect(validator.isValidMobile(number), isFalse);
  });

  test('rejects a landline number as a mobile number', () {
    // Hanoi landline.
    expect(validator.isValidMobile('+842438251234'), isFalse);
  });
}
