// Minimal example of cc_sdk_catcher: CcCatcherBootstrap builds the Catcher2
// options (crash log file + the CcCrashReporter of cc_sdk), and Catcher2
// wraps the app so every uncaught error goes through them.
import 'package:catcher_2/catcher_2.dart';
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_catcher/export_cc_sdk_catcher.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logFile = await CcCrashLogPaths.resolveLogFile();
  const reporter = CcNoopCrashReporter();
  Catcher2(
    rootWidget: const CcSdkCatcherExampleApp(),
    ensureInitialized: false,
    debugConfig: CcCatcherBootstrap.debugOptions(
      logFile,
      crashReporter: reporter,
    ),
    releaseConfig: CcCatcherBootstrap.releaseOptions(
      logFile,
      crashReporter: reporter,
    ),
  );
}

class CcSdkCatcherExampleApp extends StatelessWidget {
  const CcSdkCatcherExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cc_sdk_catcher example',
      navigatorKey: Catcher2.navigatorKey,
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => throw StateError('example crash'),
            child: const Text('Throw an error'),
          ),
        ),
      ),
    );
  }
}
