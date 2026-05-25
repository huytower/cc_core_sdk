import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/config/tokens/cc_base_colors.dart';

// Purpose:
// small reusable widgets for loading states and empty API responses
// intended as part of the shared UI library
class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(radius: 15, color: CcBaseColors.info),
    );
  }
}
