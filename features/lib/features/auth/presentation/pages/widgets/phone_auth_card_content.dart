import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

class PhoneAuthCardContent extends StatelessWidget {
  const PhoneAuthCardContent({
    super.key,
    required this.isCodeSent,
    required this.countryCode,
    required this.phoneController,
    required this.codeController,
    required this.onCountryCodeTap,
    required this.onContinue,
    required this.isLoading,
    required this.errorMessage,
  });

  final bool isCodeSent;
  final String countryCode;
  final TextEditingController phoneController;
  final TextEditingController codeController;
  final VoidCallback onCountryCodeTap;
  final VoidCallback onContinue;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CcSpaceLG(),

        // Speech bubble icon
        const CcSpeechBubbleIcon(),

        const CcSpaceLG(),

        // Title
        CcText(
          isCodeSent
              ? el.tr(CcLocaleKeys.auth_enter_code)
              : el.tr(CcLocaleKeys.auth_enter_phone_number),
          maxLines: 2,
          align: Alignment.center,
          textStyle: context.ccTextTheme.headlineMedium?.copyWith(
            fontWeight: CcTypographyParams.bold,
            color: context.ccColorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),

        const CcSpaceXL(),

        if (!isCodeSent) ...[
          // Phone number input
          CcPhoneNumberInput(
            countryCode: countryCode,
            onCountryCodeTap: onCountryCodeTap,
            controller: phoneController,
            hintText: el.tr(CcLocaleKeys.auth_phone_number_hint),
          ),
        ] else ...[
          // Code input
          TextField(
            controller: codeController,
            style: context.ccTextTheme.bodyMedium?.copyWith(
              color: context.ccColorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: el.tr(CcLocaleKeys.auth_enter_code),
              hintStyle: context.ccTextTheme.bodyMedium?.copyWith(
                color: context.ccColorScheme.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.respDim(CcPaddingParams.DESC_SM),
                ),
                borderSide: BorderSide(
                  color: context.ccColorScheme.outline,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.respDim(CcPaddingParams.DESC_SM),
                ),
                borderSide: BorderSide(
                  color: context.ccColorScheme.outline,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.respDim(CcPaddingParams.DESC_SM),
                ),
                borderSide: BorderSide(
                  color: context.ccColorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: context.respPadding(CcPaddingParams.DESC_MD),
                vertical: context.respPadding(CcPaddingParams.DESC_MD),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ],

        if (errorMessage != null) ...[
          const CcSpaceMD(),
          CcText(
            el.tr(errorMessage!),
            maxLines: 8,
            textStyle: context.ccTextTheme.bodySmall?.copyWith(
              color: context.ccColorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],

        const CcSpaceMD(),

        // Continue/Verify button
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          CcBaseBtn(
            onTap: onContinue,
            title: isCodeSent
                ? el.tr(CcLocaleKeys.auth_verify)
                : el.tr(CcLocaleKeys.common_continue),
            bgColor: [
              context.ccColorScheme.primary,
              context.ccColorScheme.primary,
            ],
            textColor: context.ccColorScheme.onPrimary,
          ),
        const CcSpaceLG(),
      ],
    );
  }
}
