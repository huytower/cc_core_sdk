import 'package:flutter/material.dart';
import 'package:theme/data/data_source/color/prj_color.dart';

// Purpose:
// full-page status/error views for the application
// more specific to app flow and user-facing status screens

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(color: PrjColors.error));
  }
}
