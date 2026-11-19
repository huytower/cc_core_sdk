import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

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

  @override
  Widget build(BuildContext context) {
    final flagEmoji = isoCode == null
        ? '🌐'
        : CcPhoneNumberHelper.flagEmoji(isoCode!);

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
