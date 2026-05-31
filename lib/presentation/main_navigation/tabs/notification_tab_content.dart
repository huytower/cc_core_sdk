import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

class NotificationTabContent extends StatelessWidget {
  const NotificationTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_rounded, size: 64),
          const SizedBox(height: 16),
          CcText(
            context.tr(CcLocaleKeys.nav_notification),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
