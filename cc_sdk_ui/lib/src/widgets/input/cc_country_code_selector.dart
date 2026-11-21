import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

class CcCountryCodeSelector extends StatelessWidget {
  const CcCountryCodeSelector({
    super.key,
    required this.countryCode,
    required this.onTap,
    this.isoCode,
  });

  /// Dial code shown next to the flag, e.g. `+84`.
  final String countryCode;
  final VoidCallback onTap;

  /// ISO 3166-1 alpha-2 code of the selected country, e.g. `VN`. A dial code
  /// alone is ambiguous (`+1` is both the US and Canada), so the flag comes
  /// from this; a globe is shown when it is null.
  final String? isoCode;

  /// Flag emoji for an ISO 3166-1 alpha-2 code (`VN` -> 🇻🇳), built from
  /// Unicode regional-indicator letters; 🌐 when [isoCode] is null or not two
  /// ASCII letters. Same rule as `CcPhoneNumberHelper.flagEmoji` in `cc_sdk`,
  /// kept here so the design system does not depend on `cc_sdk`.
  static String flagFor(String? isoCode) {
    final code = isoCode?.toUpperCase() ?? '';
    if (!RegExp(r'^[A-Z]{2}$').hasMatch(code)) return '🌐';
    return String.fromCharCodes(
      code.codeUnits.map((unit) => unit - 0x41 + 0x1F1E6),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flagEmoji = flagFor(isoCode);

    return CcBouncing(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        context.respDim(CcPaddingParams.DESC_SM),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.respPadding(CcPaddingParams.DESC_XS),
          vertical: context.respPadding(CcPaddingParams.DESC_XS),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: context.ccColorScheme.outline, width: 1),
          borderRadius: BorderRadius.circular(
            context.respDim(CcPaddingParams.DESC_SM),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CcText(
              flagEmoji,
              textStyle: context.ccTextTheme.bodyLarge?.copyWith(
                fontSize: context.respDim(20),
              ),
            ),
            SizedBox(width: context.respPadding(CcPaddingParams.DESC_XS)),
            CcText(
              countryCode,
              textStyle: context.ccTextTheme.bodyMedium?.copyWith(
                color: context.ccColorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
