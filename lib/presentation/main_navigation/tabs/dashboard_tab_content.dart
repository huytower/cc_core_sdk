import 'package:cc_sdk_ui/core/config/tokens/cc_typography_params.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:easy_localization/easy_localization.dart' as el;
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
            el.tr(CcLocaleKeys.nav_dashboard),
            fontSize: CcTypographyParams.headlineSmall,
            fontWeight: CcTypographyParams.bold,
          ),
        ],
      ),
    );
  }
}
