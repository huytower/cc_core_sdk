import 'dart:ui';

import 'package:cc_sdk_ui/core/config/tokens/base_colors.dart';
import 'package:flutter/material.dart';

/// load Background thumbnail ui from server api, attr : scale
class BackgroundScaleWidget extends StatelessWidget {
  const BackgroundScaleWidget({Key? key, @required this.thumbnail})
    : super(key: key);

  final String? thumbnail;

  @override
  Widget build(BuildContext context) => Transform.scale(
    scale: 3,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: NetworkImage(thumbnail!),
          fit: BoxFit.fitHeight,
        ),
      ),
    ),
  );
}

/// load Background thumbnail ui from server api, attr : blur
class BackgroundBlurWidget extends StatelessWidget {
  const BackgroundBlurWidget({
    Key? key,
    required this.blurX,
    required this.blurY,
  }) : super(key: key);

  final double blurX, blurY;

  @override
  Widget build(BuildContext context) => ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: BaseColors.white20,
          backgroundBlendMode: BlendMode.screen,
          shape: BoxShape.rectangle,
        ),
      ),
    ),
  );
}
