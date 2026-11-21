// Minimal example of cc_sdk_device: device-plugin implementations of the
// cc_sdk location and speech interfaces.
//
// - CcDeviceLocationService (geolocator, geocoding, permission_handler) as
//   CcLocationService.
// - CcSpeechToTextRecognizer (speech_to_text) as CcSpeechRecognizer.
//
// The page depends on the interfaces only. In a real app the implementations
// come from DI: add ExternalModule(CcSdkDevicePackageModule) to
// externalPackageModulesBefore. The host app still declares the platform
// permissions (location, microphone, speech) in its manifest / Info.plist.
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_device/export_cc_sdk_device.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(
    CcSdkDeviceExampleApp(
      location: CcDeviceLocationService(),
      speech: CcSpeechToTextRecognizer(SpeechToText()),
    ),
  );
}

class CcSdkDeviceExampleApp extends StatelessWidget {
  const CcSdkDeviceExampleApp({
    super.key,
    required this.location,
    required this.speech,
  });

  final CcLocationService location;
  final CcSpeechRecognizer speech;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cc_sdk_device example',
      home: ExampleDevicePage(location: location, speech: speech),
    );
  }
}

class ExampleDevicePage extends StatefulWidget {
  const ExampleDevicePage({
    super.key,
    required this.location,
    required this.speech,
  });

  final CcLocationService location;
  final CcSpeechRecognizer speech;

  @override
  State<ExampleDevicePage> createState() => _ExampleDevicePageState();
}

class _ExampleDevicePageState extends State<ExampleDevicePage> {
  String _place = '';
  String _words = '';
  bool _listening = false;

  Future<void> _locate() async {
    final position = await widget.location.getCurrentPosition();
    final country = position == null
        ? null
        : await widget.location.countryCodeAt(position);
    if (!mounted) return;
    setState(() {
      _place = position == null
          ? 'Location unavailable'
          : '${position.latitude.toStringAsFixed(4)}, '
                '${position.longitude.toStringAsFixed(4)} '
                '(${country ?? 'unknown country'})';
    });
  }

  Future<void> _toggleDictation() async {
    if (_listening) {
      await widget.speech.stopListening();
      return;
    }
    final started = await widget.speech.startListening(
      onResult: (words, _) => setState(() => _words = words),
      onListeningStopped: () {
        if (mounted) setState(() => _listening = false);
      },
    );
    if (!mounted) return;
    setState(() {
      _listening = started;
      if (!started) _words = 'Speech recognition unavailable';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device capabilities')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton(onPressed: _locate, child: const Text('Locate me')),
          Text(_place),
          OutlinedButton(
            onPressed: _toggleDictation,
            child: Text(_listening ? 'Stop' : 'Dictate'),
          ),
          Text(_words),
        ],
      ),
    );
  }
}
