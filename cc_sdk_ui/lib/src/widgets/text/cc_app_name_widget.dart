import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../../core/config/tokens/cc_typography_params.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import 'cc_text.dart';

class CcAppNameWidget extends StatelessWidget {
  const CcAppNameWidget(
    this.name, {
    Key? key,
    this.fontSize = 24,
    this.color,
    this.align,
  }) : super(key: key);

  final String name;

  final double fontSize;

  final Color? color;

  final Alignment? align;

  @override
  Widget build(BuildContext context) => CcText(
    name,
    align: align ?? Alignment.center,
    fontWeight: CcTypographyParams.bold,
    fontSize: context.respFontSize(fontSize),
    color: color ?? CcBaseColors.neutral40,
  );
}
