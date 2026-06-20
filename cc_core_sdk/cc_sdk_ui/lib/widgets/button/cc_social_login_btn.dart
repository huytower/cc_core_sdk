import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';
import 'cc_bounce_animation.dart';

enum SocialLoginType { google, facebook, apple }

enum CcInteractionType {
  none,
  tap,
  bounce,
}

class CcSocialLoginBtn extends StatelessWidget {
  final SocialLoginType type;
  final VoidCallback? onTap;
  final CcInteractionType interactionType;

  // Private internal constructor
  const CcSocialLoginBtn._({
    required this.type,
    required this.interactionType,
    this.onTap,
    super.key,
  });

  // Named constructors
  factory CcSocialLoginBtn.bouncing({
    required SocialLoginType type,
    required VoidCallback onTap,
    Key? key,
  }) =>
      CcSocialLoginBtn._(
        type: type,
        interactionType: CcInteractionType.bounce,
        onTap: onTap,
        key: key,
      );

  factory CcSocialLoginBtn.simple({
    required SocialLoginType type,
    required VoidCallback onTap,
    Key? key,
  }) =>
      CcSocialLoginBtn._(
        type: type,
        interactionType: CcInteractionType.tap,
        onTap: onTap,
        key: key,
      );

  factory CcSocialLoginBtn.static({
    required SocialLoginType type,
    Key? key,
  }) =>
      CcSocialLoginBtn._(
        type: type,
        interactionType: CcInteractionType.none,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    final child = Container(
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
            _getButtonText(),
            textStyle: context.ccTextTheme.bodyMedium?.copyWith(
              color: _getTextColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    switch (interactionType) {
      case CcInteractionType.none:
        return child;
      case CcInteractionType.tap:
        return GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: child,
        );
      case CcInteractionType.bounce:
        return CcBounceAnimation(
          onTap: onTap ?? () {},
          child: child,
        );
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (type) {
      case SocialLoginType.google:
        return Colors.white;
      case SocialLoginType.facebook:
        return const Color(0xFF1877F2);
      case SocialLoginType.apple:
        return Colors.black;
    }
  }

  Color _getBorderColor(BuildContext context) {
    switch (type) {
      case SocialLoginType.google:
        return const Color(0xFFDADCE0);
      case SocialLoginType.facebook:
        return const Color(0xFF1877F2);
      case SocialLoginType.apple:
        return Colors.black;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (type) {
      case SocialLoginType.google:
        return const Color(0xFF202124);
      case SocialLoginType.facebook:
        return Colors.white;
      case SocialLoginType.apple:
        return Colors.white;
    }
  }

  Widget _getIcon() {
    switch (type) {
      case SocialLoginType.google:
        return const _GoogleIcon();
      case SocialLoginType.facebook:
        return const _FacebookIcon();
      case SocialLoginType.apple:
        return const _AppleIcon();
    }
  }

  String _getButtonText() {
    switch (type) {
      case SocialLoginType.google:
        return 'Sign in with Google';
      case SocialLoginType.facebook:
        return 'Sign in with Facebook';
      case SocialLoginType.apple:
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
    return Icon(Icons.facebook, color: Colors.white, size: context.respDim(24));
  }
}

class _AppleIcon extends StatelessWidget {
  const _AppleIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.apple, color: Colors.white, size: context.respDim(24));
  }
}
