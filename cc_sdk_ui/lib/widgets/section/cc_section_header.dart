import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

class CcSectionHeader extends StatelessWidget {
  const CcSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.actions,
  });

  final String title;
  final IconData icon;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final scheme = context.ccColorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CcText(
          title,
          textStyle: context.ccTextTheme.titleSmall?.copyWith(
            fontWeight: CcTypographyParams.bold,
            color: scheme.onSurface,
          ),
        ),
        const CcSpaceXS(),
        CcIconToken(
          icon,
          size: 20,
          color: scheme.primary,
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: actions,
        ),
      ],
    );
  }
}
