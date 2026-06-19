import 'package:auto_route/auto_route.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart' hide getIt;
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../bloc/phone_auth_bloc.dart';
import '../bloc/phone_auth_event.dart';
import '../bloc/phone_auth_state.dart';
import 'widgets/phone_auth_gradient_container.dart';
import 'widgets/phone_otp_input.dart';

@RoutePage()
class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  late final TextEditingController _codeController;
  final Logger _logger = Logger(printer: SimplePrinter());

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handleVerify() {
    context.read<PhoneAuthBloc>().add(
      SignInWithCodeStarted(_codeController.text),
    );
  }

  void _handleEditPhoneNumber() {
    context.read<PhoneAuthBloc>().add(const ResetPhoneAuthStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneAuthBloc, PhoneAuthState>(
      listener: _onStateChanged,
      child: PhoneAuthGradientContainer(child: _buildCard(context)),
    );
  }

  void _onStateChanged(BuildContext context, PhoneAuthState state) {
    if (state is PhoneAuthSuccess) {
      _logger.i(
        'OtpVerificationPage: PhoneAuthSuccess received, navigating to ${CcRouteConfig.mainNavigation}',
      );
      // Using replacePath to avoid circular dependency between features and app shell router
      context.router.replacePath(CcRouteConfig.mainNavigation);
    }
  }

  Widget _buildCard(BuildContext context) {
    final phoneNumber = context.select(
      (PhoneAuthBloc bloc) => bloc.phoneNumber,
    );

    return Container(
      constraints: BoxConstraints(
        maxWidth: context.isPortrait
            ? context.respDim(500)
            : context.respDim(600),
      ),
      decoration: BoxDecoration(
        color: context.ccColorScheme.surface,
        borderRadius: BorderRadius.circular(
          context.respDim(CcPaddingParams.DESC_LG),
        ),
        boxShadow: [
          BoxShadow(
            color: context.ccColorScheme.shadow.withOpacity(0.1),
            blurRadius: context.respDim(20),
            offset: Offset(0, context.respDim(10)),
          ),
        ],
      ),
      padding: EdgeInsets.all(context.respPadding(CcPaddingParams.PAGE_MD)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CcSpaceLG(),
          const CcSpeechBubbleIcon(),
          const CcSpaceLG(),
          _buildTitle(context),
          const CcSpaceSM(),
          _buildPhoneSubtitle(context, phoneNumber),
          const CcSpaceXL(),
          _buildOtpInput(),
          const CcSpaceXL(),
          _buildErrorSection(),
          _buildActionBtn(),
          const CcSpaceLG(),
          _buildResendSection(context),
          const CcSpaceLG(),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return CcText(
      el.tr(CcLocaleKeys.auth_we_just_sent_sms),
      maxLines: 2,
      align: Alignment.center,
      textStyle: context.ccTextTheme.headlineMedium?.copyWith(
        fontWeight: CcTypographyParams.bold,
        color: context.ccColorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPhoneSubtitle(BuildContext context, String? phoneNumber) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CcText(
          '${el.tr(CcLocaleKeys.auth_enter_security_code)}',
          align: Alignment.center,
          textAlign: TextAlign.center,
          textStyle: context.ccTextTheme.bodyMedium?.copyWith(
            color: context.ccColorScheme.onSurfaceVariant,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CcText(
              '${phoneNumber ?? ""}',
              align: Alignment.center,
              textAlign: TextAlign.center,
              textStyle: context.ccTextTheme.bodyMedium?.copyWith(
                color: context.ccColorScheme.onSurfaceVariant,
              ),
            ),
            const CcSpaceXS(),
            IconButton(
              onPressed: _handleEditPhoneNumber,
              icon: Icon(
                Icons.edit_outlined,
                size: context.respDim(16),
                color: context.ccColorScheme.primary,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return PhoneOtpInput(
      controller: _codeController,
      onCompleted: (_) => _handleVerify(),
    );
  }

  Widget _buildErrorSection() {
    return BlocSelector<PhoneAuthBloc, PhoneAuthState, String?>(
      selector: (state) => state is PhoneAuthError ? state.message : null,
      builder: (context, errorMessage) {
        if (errorMessage == null) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.only(
            bottom: context.respPadding(CcPaddingParams.DESC_MD),
          ),
          child: CcText(
            el.tr(errorMessage),
            maxLines: 8,
            textStyle: context.ccTextTheme.bodySmall?.copyWith(
              color: context.ccColorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildActionBtn() {
    return BlocSelector<PhoneAuthBloc, PhoneAuthState, bool>(
      selector: (state) => state is PhoneAuthLoading,
      builder: (context, isLoading) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: _codeController,
          builder: (context, value, _) {
            final bool isOtpFilled = value.text.length == 6;
            final bool isEnabled = !isLoading && isOtpFilled;

            return NextBtn(
              onTap: _handleVerify,
              isEnable: isEnabled,
              title: el.tr(CcLocaleKeys.auth_verify),
            );
          },
        );
      },
    );
  }

  Widget _buildResendSection(BuildContext context) {
    return Column(
      children: [
        CcText(
          el.tr(CcLocaleKeys.auth_didnt_receive_code),
          align: Alignment.center,
          textAlign: TextAlign.center,
          textStyle: context.ccTextTheme.bodyMedium?.copyWith(
            color: context.ccColorScheme.onSurfaceVariant,
          ),
        ),
        const CcSpaceXS(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CcText(
              '${el.tr(CcLocaleKeys.auth_resend)} - ',
              textStyle: context.ccTextTheme.bodyMedium?.copyWith(
                color: context.ccColorScheme.primary,
                fontWeight: CcTypographyParams.bold,
              ),
            ),
            CcCountDown(
              seconds: 60,
              onTimerFinish: () {},
              style: context.ccTextTheme.bodyMedium?.copyWith(
                color: context.ccColorScheme.primary,
                fontWeight: CcTypographyParams.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
