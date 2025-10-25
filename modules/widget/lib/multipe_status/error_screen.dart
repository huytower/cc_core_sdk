import 'package:flutter/material.dart';
import 'package:theme/data/data_source/color/prj_color.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: PrjColorsSimple.red,
      ),
    );
  }
}
