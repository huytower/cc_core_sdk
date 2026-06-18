import 'package:auto_route/annotations.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

@RoutePage()
class PhoneAuthPage extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController codeController;
  final bool isLoading;
  final bool isCodeSent;
  final String? errorMessage;
  final VoidCallback onVerifyPressed;
  final VoidCallback onSignInPressed;

  const PhoneAuthPage({
    super.key,
    required this.phoneController,
    required this.codeController,
    required this.onVerifyPressed,
    required this.onSignInPressed,
    this.isLoading = false,
    this.isCodeSent = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CcText(el.tr(CcLocaleKeys.auth_login_phone)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CcBackBtn(
          onPress: () => Navigator.of(context).pop(),
          icon: Icons.arrow_back,
        ),
      ),
      backgroundColor: context.ccColorScheme.surface,
      body: SafeArea(
        child: CcResponsiveContainer(
          padding: EdgeInsets.all(context.respPadding(CcPaddingParams.PAGE_MD)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isCodeSent) ...[
                CcText(
                  el.tr(CcLocaleKeys.auth_phone_number),
                  textStyle: context.ccTextTheme.titleLarge,
                ),
                const CcSpaceLG(),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: el.tr(CcLocaleKeys.auth_phone_number),
                    prefixIcon: const Icon(Icons.phone),
                    hintText: el.tr(CcLocaleKeys.auth_phone_hint),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const CcSpaceXL(),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  CcBaseBtn(
                    onTap: onVerifyPressed,
                    title: el.tr(CcLocaleKeys.auth_send_code),
                  ),
              ] else ...[
                CcText(
                  el.tr(CcLocaleKeys.auth_enter_code),
                  textStyle: context.ccTextTheme.titleLarge,
                ),
                const CcSpaceLG(),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: el.tr(CcLocaleKeys.auth_enter_code),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const CcSpaceXL(),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  CcBaseBtn(
                    onTap: onSignInPressed,
                    title: el.tr(CcLocaleKeys.auth_verify),
                  ),
              ],
              if (errorMessage != null) ...[
                const CcSpaceLG(),
                CcText(
                  el.tr(errorMessage!),
                  textStyle: context.ccTextTheme.bodySmall?.copyWith(
                    color: context.ccColorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
