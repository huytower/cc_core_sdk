import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../../core/helper/cc_widget_helper.dart';
import '../icon/cc_icon.dart';
import '../inkwell/cc_inkwell.dart';
import '../padding/cc_padding.dart';

class CcBackBtn extends StatelessWidget {
  const CcBackBtn({super.key, required this.onPress, required this.icon});

  final VoidCallback onPress;
  final IconData icon;

  @override
  Widget build(BuildContext context) => CcPadding(
    Stack(
      children: [
        CcIcon(
          icon: icon,
          size: context.respIconSize(baseSize: 20.0),
          align: Alignment.center,
          color: context.ccColorScheme.onSurface,
        ),
        CcInkWell(
          onTap: onPress,
          borderRadius: CcWidgetHelper.getCircleBorderRadius(),
        ),
      ],
    ),
    context.respPadding(4),
    context.respPadding(4),
    context.respPadding(4),
    context.respPadding(4),
  );
}

/// use *.svg only
class CcBackAssetBtn extends StatelessWidget {
  const CcBackAssetBtn(
    this.assetRes, {
    super.key,
    this.onTap,
    this.aspectRatio = 16 / 9,
  });

  final VoidCallback? onTap;
  final String assetRes;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) => CcInkWell(
    onTap: onTap ?? () => context.router.back(),
    borderRadius: CcWidgetHelper.getCircleBorderRadius(),
    child: SizedBox(
      height: context.respDim(45.0),
      width: context.respDim(45.0),
      child: Center(
        child: SvgPicture.asset(
          assetRes,
          height: context.respIconSize(baseSize: 22.0),
          width: context.respIconSize(baseSize: 22.0),
        ),
      ),
    ),
  );
}

class CcBackDividerBtn extends StatelessWidget {
  const CcBackDividerBtn({super.key, required this.onPress});

  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final double heightBack = context.respDim(5);
    final double widthBack = context.respDim(36);
    final double paddingBack = context.respPadding(14);

    return Positioned(
      left: context.screenWidth / 2 - widthBack / 2,
      top: paddingBack,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: paddingBack),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.ccColorScheme.outlineVariant,
                borderRadius: BorderRadius.all(
                  Radius.circular(context.respDim(4)),
                ),
              ),
              child: SizedBox(width: widthBack, height: heightBack),
            ),
          ),
          CcInkWell(
            onTap: onPress,
            borderRadius: BorderRadius.all(Radius.circular(context.respDim(4))),
            child: SizedBox(width: widthBack, height: heightBack),
          ),
        ],
      ),
    );
  }
}
