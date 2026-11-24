import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:injectable/injectable.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/// [CcPhoneNumberValidator] with per-country numbering rules
/// (`phone_numbers_parser`, a port of Google's libphonenumber metadata).
@LazySingleton(as: CcPhoneNumberValidator)
class CcLibPhoneNumberValidator implements CcPhoneNumberValidator {
  const CcLibPhoneNumberValidator();

  /// e.g. `+84939722577` is valid. A trunk zero kept after the country code
  /// (`+840939722577`) is tolerated: the library drops it, and
  /// [formatInternational] returns the normalized `+84939722577`.
  @override
  bool hasValidMobile(String internationalNumber) =>
      _parseMobile(internationalNumber) != null;

  @override
  String? formatInternational(String internationalNumber) =>
      _parseMobile(internationalNumber)?.international;

  PhoneNumber? _parseMobile(String number) {
    if (number.trim().isEmpty) return null;
    try {
      final parsed = PhoneNumber.parse(number);
      return parsed.isValid(type: PhoneNumberType.mobile) ? parsed : null;
    } catch (_) {
      return null;
    }
  }
}
