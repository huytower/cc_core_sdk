import 'package:flutter/material.dart';

import '../../../../core/config/tokens/base_colors.dart';

// Purpose:
// full-page status/error views for the application
// more specific to app flow and user-facing status screens

class CcNotFoundPage extends StatelessWidget {
  const CcNotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(color: BaseColors.error));
  }
}
