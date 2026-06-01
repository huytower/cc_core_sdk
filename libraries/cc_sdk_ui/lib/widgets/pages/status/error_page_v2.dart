import 'package:flutter/material.dart';

import '../../../../core/config/tokens/cc_base_colors.dart';

// Purpose:
// small reusable widgets for loading states and empty API responses
// intended as part of the shared UI library
class ErrorPageV2 extends StatelessWidget {
  const ErrorPageV2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Theme.of(context).colorScheme.error),
    );
  }
}
