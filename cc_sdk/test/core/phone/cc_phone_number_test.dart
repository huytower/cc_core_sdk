import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CcPhoneNumberHelper', () {
    test('autoParsePhoneNumber drops the national trunk zero', () {
      expect(
        CcPhoneNumberHelper.autoParsePhoneNumber('+84', '0939722577'),
        '+84939722577',
      );
      expect(
        CcPhoneNumberHelper.autoParsePhoneNumber('+84', '939722577'),
        '+84939722577',
      );
    });

    test('flagEmoji maps ISO codes to flags', () {
      expect(CcPhoneNumberHelper.flagEmoji('vn'), '🇻🇳');
      expect(CcPhoneNumberHelper.flagEmoji('X'), '🌐');
    });
  });

  group('CcBasicPhoneNumberValidator', () {
    const validator = CcBasicPhoneNumberValidator();

    test('accepts E.164 numbers, spaces and dashes included', () {
      expect(validator.isValidMobile('+84939722577'), isTrue);
      expect(validator.isValidMobile('+1 415-555-2671'), isTrue);
      expect(validator.formatInternational('+84 939 722 577'), '+84939722577');
    });

    test('rejects numbers that are not E.164', () {
      expect(validator.isValidMobile('0939722577'), isFalse);
      expect(validator.isValidMobile('+0939722577'), isFalse);
      expect(validator.isValidMobile('+12'), isFalse);
      expect(validator.formatInternational('abc'), isNull);
    });
  });
}
