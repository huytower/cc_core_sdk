import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../core/config/tokens/base_colors.dart';

class SpinKitScreen extends StatefulWidget {
  const SpinKitScreen({Key? key}) : super(key: key);

  @override
  _SpinKitState createState() => _SpinKitState();
}

class _SpinKitState extends State<SpinKitScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: BaseColors.surfaceDefault,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12.0),
            child: SpinKitThreeBounce(
              color: BaseColors.actionPrimary,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
