import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import 'cc_text.dart';

class TitleWarningWidget extends StatelessWidget {
  const TitleWarningWidget({Key? key, required this.title, this.textColor})
    : super(key: key);

  final String title;

  final Color? textColor;

  @override
  Widget build(BuildContext context) => CcText(
    title,
    align: Alignment.centerLeft,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: textColor ?? context.ccColorScheme.error,
  );
}
