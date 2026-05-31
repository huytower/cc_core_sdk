import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:message/cc_locale_keys.dart';
import 'package:message/cc_localization.dart';

class ProfileTabContent extends StatelessWidget {
  const ProfileTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_rounded, size: 64),
          const SizedBox(height: 16),
          CcText(
            context.tr(CcLocaleKeys.nav_profile),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
