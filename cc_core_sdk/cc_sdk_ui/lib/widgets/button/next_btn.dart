import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import 'cc_base_btn.dart';

class NextBtn extends StatelessWidget {
  const NextBtn({
    super.key,
    required this.onTap,
    this.title,
    this.isEnable = true,
  });

  final VoidCallback onTap;
  final String? title;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return CcBaseBtn(
      onTap: onTap,
      isEnable: isEnable,
      title: title ?? el.tr(CcLocaleKeys.common_next),
      bgColor: isEnable
          ? [context.ccColorScheme.primary, context.ccColorScheme.primary]
          : null, // Fallback to surfaceVariant in CcBaseBtn
      textColor: isEnable
          ? context.ccColorScheme.onPrimary
          : null, // Fallback to onSurfaceVariant in CcBaseBtn
    );
  }
}
