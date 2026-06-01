import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

class ProfileTabContent extends StatelessWidget {
  const ProfileTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_rounded,
            size: 64,
            color: context.ccColorScheme.primary,
          ),
          const CcSpaceLG(),
          CcText(
            el.tr(CcLocaleKeys.nav_profile),
            textStyle: context.ccTextTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            align: Alignment.center,
          ),
        ],
      ),
    );
  }
}
