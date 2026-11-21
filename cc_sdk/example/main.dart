// Minimal example of cc_sdk on its own: no app module, no domain feature, no
// vendor capability package.
//
// - CcSdkConfig.configure() is the one place the app hands its settings in.
// - Capabilities are interfaces; the no-op implementations (CcNoopAnalytics,
//   CcBasicPhoneNumberValidator, ...) run without any vendor SDK. An app swaps
//   in a vendor package (cc_sdk_firebase, cc_sdk_phone, ...) through DI.
// - CcWindowSizeClass reads the space a widget is given.
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter/material.dart';

void main() {
  CcSdkConfig.configure(const CcSdkConfig(appName: 'cc_sdk example'));
  runApp(const CcSdkExampleApp());
}

class CcSdkExampleApp extends StatelessWidget {
  const CcSdkExampleApp({
    super.key,
    this.analytics = const CcNoopAnalytics(),
    this.phoneValidator = const CcBasicPhoneNumberValidator(),
  });

  final CcAnalytics analytics;
  final CcPhoneNumberValidator phoneValidator;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: CcAppTrackName.appName,
      navigatorObservers: [?analytics.navigatorObserver],
      home: ExampleHomePage(
        analytics: analytics,
        phoneValidator: phoneValidator,
      ),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({
    super.key,
    required this.analytics,
    required this.phoneValidator,
  });

  final CcAnalytics analytics;
  final CcPhoneNumberValidator phoneValidator;

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  String _phoneResult = '';

  @override
  void initState() {
    super.initState();
    widget.analytics.logScreenView(screenName: 'example_home');
  }

  void _checkPhone(String input) {
    final formatted = widget.phoneValidator.formatInternational(input);
    setState(() => _phoneResult = formatted ?? 'Invalid number');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(CcAppTrackName.appName)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final sizeClass = CcWindowSizeClass.fromConstraints(constraints);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Window size class: ${sizeClass.name}'),
              Text('Compact number: ${1500000.formatShort()}'),
              TextField(
                key: const Key('phone'),
                decoration: const InputDecoration(
                  labelText: 'Phone number (E.164)',
                ),
                onSubmitted: _checkPhone,
              ),
              Text(_phoneResult),
            ],
          );
        },
      ),
    );
  }
}
