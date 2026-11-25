import 'cc_phone_number_validator.dart';

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

