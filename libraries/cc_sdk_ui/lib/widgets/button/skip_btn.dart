import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../../core/config/tokens/cc_padding_params.dart';
import '../padding/cc_padding.dart';
import '../text/cc_text.dart';

class SkipBtn extends StatelessWidget {
  const SkipBtn({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => CcPadding(
    GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: const SizedBox(
        width: 103,
        height: 76,
        child: Center(
          child: CcText(
            'Bỏ qua',
            color: CcBaseColors.surfaceVariant,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            align: Alignment.center,
          ),
        ),
      ),
    ),
    0,
    CcPaddingParams.PAGE_LG,
    0,
    0,
  );
}
