import 'package:app_config/data_source/assets_data_source.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import 'splash_init.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Navigate after a short delay
    Future.delayed(
      const Duration(milliseconds: 200),
      () => navigateFromSplash(context),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                "packages/theme/${AssetUtils.getBackground(BackgroundAsset.splash)}",
              ),
            ),
          ),
        ),
      );
}
