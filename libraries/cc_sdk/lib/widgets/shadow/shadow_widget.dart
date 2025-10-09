import 'package:cc_sdk/core/theme/base_colors.dart';
import 'package:flutter/material.dart';

import '../../core/helper/widget_helper.dart';

class ShadowWidget extends StatelessWidget {
  const ShadowWidget(this.widget,
      {Key? key,
      this.bgColor,
      this.shadowColor,
      this.borderRadius,
      this.elevation = 8})
      : super(key: key);

  final BorderRadius? borderRadius;

  final Color? bgColor, shadowColor;

  final double elevation;

  final Widget widget;

  @override
  Align build(context) => Align(
        alignment: Alignment.center,
        child: Material(
          borderRadius: borderRadius ?? WidgetHelper.getCircleBorderRadius(),
          color: bgColor ?? BaseColors.white_80,
          elevation: elevation,
          shadowColor: shadowColor ?? BaseColors.pink_30,
          child: widget,
        ),
      );
}
