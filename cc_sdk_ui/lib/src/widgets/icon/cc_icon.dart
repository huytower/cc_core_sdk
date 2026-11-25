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
