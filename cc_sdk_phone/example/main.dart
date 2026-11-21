// Minimal example of cc_sdk_phone: CcLibPhoneNumberValidator implements the
// CcPhoneNumberValidator interface from cc_sdk with full per-country rules
// (phone_numbers_parser). The app depends on the interface only; swap in
// CcBasicPhoneNumberValidator (cc_sdk, no dependency) to drop this package.
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_phone/export_cc_sdk_phone.dart';
import 'package:flutter/material.dart';

void main() => runApp(const CcSdkPhoneExampleApp());

class CcSdkPhoneExampleApp extends StatelessWidget {
  const CcSdkPhoneExampleApp({
    super.key,
    this.validator = const CcLibPhoneNumberValidator(),
  });

  final CcPhoneNumberValidator validator;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cc_sdk_phone example',
      home: ExamplePhonePage(validator: validator),
    );
  }
}

class ExamplePhonePage extends StatefulWidget {
  const ExamplePhonePage({super.key, required this.validator});

  final CcPhoneNumberValidator validator;

  @override
  State<ExamplePhonePage> createState() => _ExamplePhonePageState();
}

class _ExamplePhonePageState extends State<ExamplePhonePage> {
  String _countryCode = '+84';
  String _result = '';

  void _check(String nationalNumber) {
    final international = CcPhoneNumberHelper.autoParsePhoneNumber(
      _countryCode,
      nationalNumber.trim(),
    );
    final formatted = widget.validator.formatInternational(international);
    setState(() => _result = formatted ?? 'Not a valid mobile number');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check a mobile number')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButton<String>(
            value: _countryCode,
            items: [
              for (final (code, iso) in const [
                ('+84', 'VN'),
                ('+1', 'US'),
                ('+44', 'GB'),
              ])
                DropdownMenuItem(
                  value: code,
                  child: Text('${CcPhoneNumberHelper.flagEmoji(iso)} $code'),
                ),
            ],
            onChanged: (code) => setState(() => _countryCode = code!),
          ),
          TextField(
            key: const Key('phone'),
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Mobile number'),
            onSubmitted: _check,
          ),
          Text(_result),
        ],
      ),
    );
  }
}
