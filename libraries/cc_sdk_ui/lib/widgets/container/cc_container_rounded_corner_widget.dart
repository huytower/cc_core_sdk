import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/helper/cc_widget_helper.dart';

class CcContainerRoundedCorner extends StatelessWidget {
  const CcContainerRoundedCorner({Key? key, this.height, this.color})
    : super(key: key);

  final Color? color;

  final double? height;

  @override
  Widget build(c) => Center(
    child: Container(
      decoration: BoxDecoration(
        color: color ?? CcBaseColors.white80,
        borderRadius: CcWidgetHelper.getBorderRoundedSmall(),
      ),
      width: Get.width,
      height: height ?? 40,
      margin: const EdgeInsets.only(
        left: CcPaddingParams.PAGE_MD,
        right: CcPaddingParams.PAGE_MD,
      ),
    ),
  );
}
