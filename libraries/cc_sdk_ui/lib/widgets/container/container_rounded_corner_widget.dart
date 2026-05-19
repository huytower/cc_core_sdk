import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/cc_padding_params.dart';
import '../../core/helper/widget_helper.dart';
import '../../core/theme/base_colors.dart';

class ContainerRoundedCorner extends StatelessWidget {
  const ContainerRoundedCorner({Key? key, this.height, this.color})
    : super(key: key);

  final Color? color;

  final double? height;

  @override
  Widget build(c) => Center(
    child: Container(
      decoration: BoxDecoration(
        color: color ?? BaseColors.white80,
        borderRadius: WidgetHelper.getBorderRoundedSmall(),
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
