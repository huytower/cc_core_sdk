import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

class DashboardTabContent extends StatelessWidget {
  const DashboardTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.dashboard_rounded, size: 64),
          const CcSpaceLG(),
          CcText(
            context.tr(CcLocaleKeys.nav_dashboard),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
