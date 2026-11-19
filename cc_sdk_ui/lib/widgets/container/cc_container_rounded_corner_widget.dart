import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../../core/helper/cc_widget_helper.dart';

class CcContainerRoundedCorner extends StatelessWidget {
  const CcContainerRoundedCorner({super.key, this.height, this.color});

  final Color? color;

  final double? height;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      decoration: BoxDecoration(
        color: color ?? context.ccColorScheme.surface.withValues(alpha: 0.8),
        borderRadius: CcWidgetHelper.getBorderRoundedSM(),
      ),
      width: double.infinity,
      height: context.respPadding(height ?? 40),
      margin: EdgeInsets.only(
        left: context.respPadding(CcPaddingParams.PAGE_MD),
        right: context.respPadding(CcPaddingParams.PAGE_MD),
      ),
    ),
  );
}
