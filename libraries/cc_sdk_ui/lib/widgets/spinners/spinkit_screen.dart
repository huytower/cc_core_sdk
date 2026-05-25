import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../core/config/tokens/cc_base_colors.dart';

class SpinkitScreen extends StatelessWidget {
  const SpinkitScreen({Key? key, this.color}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: CcBaseColors.surfaceDefault,
    body: Center(
      child: SpinKitDoubleBounce(
        color: color ?? CcBaseColors.actionPrimary,
        size: 50.0,
      ),
    ),
  );
}
