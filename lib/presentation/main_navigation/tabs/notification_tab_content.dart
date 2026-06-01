import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

class NotificationTabContent extends StatelessWidget {
  const NotificationTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_rounded,
            size: context.respIconSize(baseSize: 64.0),
            color: context.ccColorScheme.primary,
          ),
          const CcSpaceLG(),
          CcText(
            el.tr(CcLocaleKeys.nav_notification),
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
