import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

class CcNextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final bool hasEnable;
  final CcInteractionType interactionType;
  final bool useDebounce;

  // Backward compatibility constructor (defaults to bounce)
  const CcNextButton({
    super.key,
    required this.onTap,
    this.title,
    this.hasEnable = true,
    this.useDebounce = true,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const CcNextButton._({
    required this.interactionType,
    required this.onTap,
    this.title,
    this.hasEnable = true,
    this.useDebounce = true,
    super.key,
  });

  // Named constructors
  factory CcNextButton.bouncing({
    required VoidCallback onTap,
    String? title,
    bool hasEnable = true,
    bool useDebounce = true,
    Key? key,
  }) => CcNextButton._(
    interactionType: CcInteractionType.bounce,
    onTap: onTap,
    title: title,
    hasEnable: hasEnable,
    useDebounce: useDebounce,
    key: key,
  );

  factory CcNextButton.simple({
    required VoidCallback onTap,
    String? title,
    bool hasEnable = true,
    bool useDebounce = true,
    Key? key,
  }) => CcNextButton._(
    interactionType: CcInteractionType.tap,
    onTap: onTap,
    title: title,
    hasEnable: hasEnable,
    useDebounce: useDebounce,
    key: key,
  );

  factory CcNextButton.static({String? title, bool hasEnable = true, Key? key}) =>
      CcNextButton._(
        interactionType: CcInteractionType.none,
        onTap: () {},
        title: title,
        hasEnable: hasEnable,
        useDebounce: false,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    final baseButton = CcBaseButton.static(
      hasEnable: hasEnable,
      title: title ?? 'Next',
      backgroundColor: hasEnable
          ? [context.ccColorScheme.primary, context.ccColorScheme.primary]
          : null, // Fallback to surfaceVariant in CcBaseButton
      textColor: hasEnable
          ? context.ccColorScheme.onPrimary
          : null, // Fallback to onSurfaceVariant in CcBaseButton
    );

    // If type is none or not enabled, return the base button directly
    if (interactionType == CcInteractionType.none || !hasEnable) {
      return baseButton;
    }

    // Otherwise, wrap it in the interaction logic
    return CcInteractionWrapper(
      onTap: onTap,
      useDebounce: useDebounce,
      hasBouncing: interactionType == CcInteractionType.bounce,
      child: baseButton,
    );
  }
}
