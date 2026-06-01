import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/config/tokens/cc_typography_params.dart';
import '../../core/extensions/cc_context_extension.dart';
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
      child: SizedBox(
        width: 103,
        height: 76,
        child: Center(
          child: CcText(
            el.tr(CcLocaleKeys.common_skip),
            color: context.ccColorScheme.onSurfaceVariant,
            fontSize: CcTypographyParams.bodyLarge,
            fontWeight: CcTypographyParams.medium,
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
