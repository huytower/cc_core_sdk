/// Phone number validation and formatting, independent of any library.
///
/// The SDK core defines the contract and a dependency-free
/// [CcBasicPhoneNumberValidator]. A full implementation with per-country
/// numbering rules comes from a capability package (e.g.
/// `CcLibPhoneNumberValidator` in `cc_sdk_phone`), registered in DI as
/// `CcPhoneNumberValidator`.
///
/// ```dart
/// final number = CcPhoneNumberHelper.autoParsePhoneNumber('+84', '0939722577');
/// if (validator.isValidMobile(number)) sendOtp(number);
/// ```
abstract interface class CcPhoneNumberValidator {
  /// Whether [internationalNumber] (with its `+` country code, e.g.
  /// `+84939722577`) is a valid mobile number.
  bool hasValidMobile(String internationalNumber);

  /// [internationalNumber] in readable international format (e.g.
  /// `+84 93 972 25 77`), or null if it is not a valid mobile number.
  String? formatInternational(String internationalNumber);
}

/// [CcPhoneNumberValidator] that only checks the E.164 shape (`+`, then 7-15
/// digits, no leading 0 in the country code). No per-country rules: use it
/// when the app does not need them or before a full implementation.
class CcBasicPhoneNumberValidator implements CcPhoneNumberValidator {
  const CcBasicPhoneNumberValidator();

  static final RegExp _e164 = RegExp(r'^\+[1-9]\d{6,14}$');

  @override
  bool hasValidMobile(String internationalNumber) =>
      _e164.hasMatch(internationalNumber.replaceAll(RegExp(r'[\s-]'), ''));

  @override
  String? formatInternational(String internationalNumber) {
    final compact = internationalNumber.replaceAll(RegExp(r'[\s-]'), '');
    return hasValidMobile(compact) ? compact : null;
  }
}
