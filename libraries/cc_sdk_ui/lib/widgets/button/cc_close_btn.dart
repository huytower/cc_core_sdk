import 'package:cc_sdk/core/helper/cc_image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../inkwell/cc_inkwell.dart';

/// Use *.svg|icon|*.png assets
class CcCloseBtn extends StatelessWidget {
  final Color bgColor;
  final double? height, width;
  final Widget? icon;
  final String src;
  final VoidCallback onTap;

  const CcCloseBtn({
    super.key,
    this.bgColor = Colors.transparent,
    this.height,
    this.icon,
    required this.onTap,
    this.src = '',
    this.width,
  });

  @override
  Widget build(BuildContext context) =>
      CcInkWell(onTap: onTap, child: buildSizedBox());

  Widget buildContainer() => Container(
    alignment: Alignment.center,
    height: 20.0,
    width: 20.0,
    color: bgColor,
    child: buildIcon(),
  );

  Widget buildIcon() =>
      icon ??
      (CcImageHelper.isSvg(src) ? SvgPicture.asset(src) : Image.asset(src));

  Widget buildSizedBox() => Center(
    child: SizedBox(
      width: width ?? 35,
      height: height ?? 35,
      child: buildContainer(),
    ),
  );
}
