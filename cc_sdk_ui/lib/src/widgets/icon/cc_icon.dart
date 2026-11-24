import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

class CcIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final Alignment? align;
  final EdgeInsets? padding;

  const CcIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.align,
    this.padding,
  });

  @override
  Widget build(BuildContext context) => Align(
    alignment: align ?? Alignment.center,
    child: Icon(icon, size: size, color: color),
  );
}

class CcMediaIcon extends StatelessWidget {
  final bool hasVisible;
  final Color color;
  final IconData icon;
  final double? iconSize;
  final VoidCallback? onTap;
  final CcInteractionType interactionType;
  final bool useDebounce;

  // Backward compatibility constructor (defaults to bounce)
  const CcMediaIcon({
    super.key,
    this.onTap,
    required this.hasVisible,
    required this.icon,
    this.iconSize,
    required this.color,
    this.useDebounce = true,
  }) : interactionType = CcInteractionType.bounce;

  // Private internal constructor
  const CcMediaIcon._({
    required this.interactionType,
    this.onTap,
    required this.hasVisible,
    required this.icon,
    this.iconSize,
    required this.color,
    this.useDebounce = true,
    super.key,
  });

  // Named constructors
  factory CcMediaIcon.bouncing({
    VoidCallback? onTap,
    required bool hasVisible,
    required IconData icon,
    double? iconSize,
    required Color color,
    bool useDebounce = true,
    Key? key,
  }) => CcMediaIcon._(
    interactionType: CcInteractionType.bounce,
    onTap: onTap,
    hasVisible: hasVisible,
    icon: icon,
    iconSize: iconSize,
    color: color,
    useDebounce: useDebounce,
    key: key,
  );

  factory CcMediaIcon.simple({
    VoidCallback? onTap,
    required bool hasVisible,
    required IconData icon,
    double? iconSize,
    required Color color,
    bool useDebounce = true,
    Key? key,
  }) => CcMediaIcon._(
    interactionType: CcInteractionType.tap,
    onTap: onTap,
    hasVisible: hasVisible,
    icon: icon,
    iconSize: iconSize,
    color: color,
    useDebounce: useDebounce,
    key: key,
  );

  factory CcMediaIcon.static({
    required bool hasVisible,
    required IconData icon,
    double? iconSize,
    required Color color,
    Key? key,
  }) => CcMediaIcon._(
    interactionType: CcInteractionType.none,
    hasVisible: hasVisible,
    icon: icon,
    iconSize: iconSize,
    color: color,
    useDebounce: false,
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    if (!hasVisible) {
      return const SizedBox(width: 35);
    }

    final baseIcon = CcIcon(
      icon: icon,
      size: iconSize ?? context.respIconSize(baseSize: 20.0),
      color: color,
      align: Alignment.center,
    );

    // If type is none, return the base icon directly
    if (interactionType == CcInteractionType.none) {
      return baseIcon;
    }

    // Otherwise, wrap it in the interaction logic
    return CcInteractionWrapper(
      onTap: onTap ?? () {},
      useDebounce: useDebounce,
      hasBouncing: interactionType == CcInteractionType.bounce,
      child: baseIcon,
    );
  }
}
