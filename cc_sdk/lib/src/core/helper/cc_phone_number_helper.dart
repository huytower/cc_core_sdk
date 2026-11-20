/// Dependency-free phone number helpers.
///
/// Validation and formatting need per-country numbering rules: use
/// `CcPhoneNumberValidator` (see `cc_sdk_phone` for a full implementation).
class CcPhoneNumberHelper {
  CcPhoneNumberHelper._();

  /// Joins a country dial code and a national number, dropping the national
  /// trunk prefix (leading zeros).
  ///
  /// Example:
  /// - countryCode: "+84", nationalNumber: "0939722577" → returns "+84939722577"
  /// - countryCode: "+84", nationalNumber: "939722577" → returns "+84939722577"
  static String autoParsePhoneNumber(
    String countryCode,
    String nationalNumber,
  ) {
    if (countryCode.isEmpty || nationalNumber.isEmpty) {
      return '$countryCode$nationalNumber';
    }
    final parsedNationalNumber = nationalNumber.replaceFirst(
      RegExp(r'^0+'),
      '',
    );
    return '$countryCode$parsedNationalNumber';
  }

  /// Flag emoji for an ISO 3166-1 alpha-2 country code (e.g. `VN` -> 🇻🇳),
  /// built from Unicode regional-indicator letters. Returns 🌐 when [isoCode]
  /// is not two ASCII letters.
  static String flagEmoji(String isoCode) {
    final code = isoCode.toUpperCase();
    if (!RegExp(r'^[A-Z]{2}$').hasMatch(code)) return '🌐';
    return String.fromCharCodes(
      code.codeUnits.map((unit) => unit - 0x41 + 0x1F1E6),
    );
  }
}
