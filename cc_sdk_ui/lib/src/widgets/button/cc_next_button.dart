import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

class CcNextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final bool isEnable;
  final CcInteractionType interactionType;
  final bool useDebounce;

  // Backward compatibility constructor (defaults to bounce)
  const CcNextButton({
    super.key,
    required this.onTap,
    this.title,
    this.isEnable = true,
    this.useDebounce = true,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const CcNextButton._({
    required this.interactionType,
    required this.onTap,
    this.title,
    this.isEnable = true,
    this.useDebounce = true,
    super.key,
  });

  // Named constructors
  factory CcNextButton.bouncing({
    required VoidCallback onTap,
    String? title,
    bool isEnable = true,
    bool useDebounce = true,
    Key? key,
  }) => CcNextButton._(
    interactionType: CcInteractionType.bounce,
    onTap: onTap,
    title: title,
    isEnable: isEnable,
    useDebounce: useDebounce,
    key: key,
  );

  factory CcNextButton.simple({
    required VoidCallback onTap,
    String? title,
    bool isEnable = true,
    bool useDebounce = true,
    Key? key,
  }) => CcNextButton._(
    interactionType: CcInteractionType.tap,
    onTap: onTap,
    title: title,
    isEnable: isEnable,
    useDebounce: useDebounce,
    key: key,
  );

  factory CcNextButton.static({String? title, bool isEnable = true, Key? key}) =>
      CcNextButton._(
        interactionType: CcInteractionType.none,
        onTap: () {},
        title: title,
        isEnable: isEnable,
        useDebounce: false,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    final baseBtn = CcBaseButton.static(
      isEnable: isEnable,
      title: title ?? 'Next',
      bgColor: isEnable
          ? [context.ccColorScheme.primary, context.ccColorScheme.primary]
          : null, // Fallback to surfaceVariant in CcBaseButton
      textColor: isEnable
          ? context.ccColorScheme.onPrimary
          : null, // Fallback to onSurfaceVariant in CcBaseButton
    );

    // If type is none or not enabled, return the base button directly
    if (interactionType == CcInteractionType.none || !isEnable) {
      return baseBtn;
    }

    // Otherwise, wrap it in the interaction logic
    return CcInteractionWrapper(
      onTap: onTap,
      useDebounce: useDebounce,
      isBouncing: interactionType == CcInteractionType.bounce,
      child: baseBtn,
    );
  }
}
