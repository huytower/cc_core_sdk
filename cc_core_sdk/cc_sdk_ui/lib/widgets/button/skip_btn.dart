import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../padding/cc_padding.dart';
import 'cc_base_btn.dart';

class SkipBtn extends StatelessWidget {
  const SkipBtn({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => CcPadding(
    CcBaseBtn(
      onTap: onTap,
      title: el.tr(CcLocaleKeys.common_skip),
      width: context.respIconSize(baseSize: 103.0),
      height: context.respIconSize(baseSize: 76.0),
      bgColor: const [Colors.transparent, Colors.transparent],
      textColor: context.ccColorScheme.onSurfaceVariant,
    ),
    0,
    context.respPadding(CcPaddingParams.PAGE_LG),
    0,
    0,
  );
}
