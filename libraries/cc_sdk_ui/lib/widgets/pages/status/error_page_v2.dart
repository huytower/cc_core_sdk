import 'package:flutter/material.dart';
import '../../../../core/theme/base_colors.dart';

// Purpose:
// full-page status/error views for the application
// more specific to app flow and user-facing status screens

class CcErrorPageV2 extends StatelessWidget {
  const CcErrorPageV2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(color: BaseColors.error));
  }
}
