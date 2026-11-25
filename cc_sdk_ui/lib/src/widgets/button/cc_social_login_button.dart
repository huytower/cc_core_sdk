import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

class CcSocialLoginButton extends StatelessWidget {
  final CcSocialLoginType type;
  final VoidCallback? onTap;
  final CcInteractionType interactionType;
  final bool useDebounce;
  final String? label;

  // Backward compatibility constructor (defaults to bounce)
  const CcSocialLoginButton({
    super.key,
    required this.type,
    required this.onTap,
    this.useDebounce = true,
    this.label,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const CcSocialLoginButton._({
    required this.type,
    required this.interactionType,
    this.onTap,
    this.useDebounce = true,
    this.label,
    super.key,
  });

  // Named constructors
  factory CcSocialLoginButton.bouncing({
    required CcSocialLoginType type,
    required VoidCallback onTap,
    bool useDebounce = true,
    String? label,
    Key? key,
  }) => CcSocialLoginButton._(
    type: type,
    interactionType: CcInteractionType.bounce,
    onTap: onTap,
    useDebounce: useDebounce,
    label: label,
    key: key,
  );

  factory CcSocialLoginButton.simple({
    required CcSocialLoginType type,
    required VoidCallback onTap,
    bool useDebounce = true,
    String? label,
    Key? key,
  }) => CcSocialLoginButton._(
    type: type,
    interactionType: CcInteractionType.tap,
    onTap: onTap,
    useDebounce: useDebounce,
    label: label,
    key: key,
  );

  factory CcSocialLoginButton.static({
    required CcSocialLoginType type,
    String? label,
    Key? key,
  }) => CcSocialLoginButton._(
    type: type,
    interactionType: CcInteractionType.none,
    useDebounce: false,
    label: label,
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final baseButton = Container(
      height: context.respDim(48),
      width: double.infinity,
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(
          context.respDim(CcPaddingParams.DESC_SM),
        ),
        border: Border.all(color: _getBorderColor(context), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getIcon(),
          SizedBox(width: context.respPadding(CcPaddingParams.DESC_MD)),
          CcText(
            label ?? _getButtonText(),
            textStyle: context.ccTextTheme.bodyMedium?.copyWith(
              color: _getTextColor(context),
              fontWeight: CcTypographyParams.semiBold,
            ),
          ),
        ],
      ),
    );

    // If type is none, return the base button directly
    if (interactionType == CcInteractionType.none) {
      return baseButton;
    }

    // Otherwise, wrap it in the interaction logic
    return CcInteractionWrapper(
      onTap: onTap ?? () {},
      useDebounce: useDebounce,
      hasBouncing: interactionType == CcInteractionType.bounce,
      child: baseButton,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (type) {
      case CcSocialLoginType.google:
        return CcBaseColors.white100;
      case CcSocialLoginType.facebook:
        return CcBaseColors.facebookBlue;
      case CcSocialLoginType.apple:
        return CcBaseColors.neutral100;
    }
  }

  Color _getBorderColor(BuildContext context) {
    switch (type) {
      case CcSocialLoginType.google:
        return CcBaseColors.googleBorder;
      case CcSocialLoginType.facebook:
        return CcBaseColors.facebookBlue;
      case CcSocialLoginType.apple:
        return CcBaseColors.neutral100;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (type) {
      case CcSocialLoginType.google:
        return CcBaseColors.googleText;
      case CcSocialLoginType.facebook:
        return CcBaseColors.white100;
      case CcSocialLoginType.apple:
        return CcBaseColors.white100;
    }
  }

  Widget _getIcon() {
    switch (type) {
      case CcSocialLoginType.google:
        return const _GoogleIcon();
      case CcSocialLoginType.facebook:
        return const _FacebookIcon();
      case CcSocialLoginType.apple:
        return const _AppleIcon();
    }
  }

  String _getButtonText() {
    switch (type) {
      case CcSocialLoginType.google:
        return 'Sign in with Google';
      case CcSocialLoginType.facebook:
        return 'Sign in with Facebook';
      case CcSocialLoginType.apple:
        return 'Sign in with Apple';
    }
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.respDim(24),
      height: context.respDim(24),
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Google G logo
    // Red part
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(12, 12), radius: 12),
      0.785, // 45 degrees
      2.356, // 135 degrees
      false,
      paint,
    );

    // Yellow part
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(12, 12), radius: 12),
      3.141, // 180 degrees
      1.571, // 90 degrees
      false,
      paint,
    );

    // Green part
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(12, 12), radius: 12),
      4.712, // 270 degrees
      1.571, // 90 degrees
      false,
      paint,
    );

    // Blue part
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(12, 12), radius: 12),
      6.283, // 360 degrees
      1.571, // 90 degrees
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FacebookIcon extends StatelessWidget {
  const _FacebookIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.facebook,
      color: CcBaseColors.white100,
      size: context.respDim(24),
    );
  }
}

class _AppleIcon extends StatelessWidget {
  const _AppleIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.apple,
      color: CcBaseColors.white100,
      size: context.respDim(24),
    );
  }
}
