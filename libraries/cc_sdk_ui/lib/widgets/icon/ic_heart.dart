import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_base_colors.dart';

class IconHeart extends StatelessWidget {
  const IconHeart({
    Key? key,
    this.height,
    this.width,
    this.colors,
    this.isCircleIcon = false,
  }) : super(key: key);

  final double? height, width;

  final List<Color>? colors;

  final bool isCircleIcon;

  @override
  Widget build(BuildContext context) =>
      isCircleIcon ? getCircleIcon() : getIcon();

  Widget getIcon() => ShaderMask(
    shaderCallback: (Rect bounds) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors:
            colors ??
            const [CcBaseColors.actionPrimary, CcBaseColors.actionPrimary],
      ).createShader(bounds);
    },
    child: Icon(Icons.favorite, color: Colors.white, size: height ?? 20),
  );

  Widget getCircleIcon() => Container(
    width: width ?? 30,
    height: height ?? 30,
    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    child: getIcon(),
  );
}
