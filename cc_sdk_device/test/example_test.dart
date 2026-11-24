import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_device/export_cc_sdk_device.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../example/main.dart';

class _FakeLocation extends CcNoopLocationService {
  @override
  Future<CcGeoPosition?> getCurrentPosition() async =>
      const CcGeoPosition(latitude: 21.0285, longitude: 105.8542);

  @override
  Future<String?> countryCodeAt(CcGeoPosition position) async => 'VN';
}

/// Delivers [words] as soon as listening starts; stop ends the session.
class _FakeSpeech implements CcSpeechRecognizer {
  _FakeSpeech(this.words);

  final String words;
  VoidCallback? _onStopped;
  bool _listening = false;

  @override
  bool get hasListening => _listening;

  @override
  Future<bool> startListening({
    required void Function(String recognizedWords, bool hasFinal) onResult,
    void Function()? onListeningStopped,
    String? localeId,
  }) async {
    _listening = true;
    _onStopped = onListeningStopped;
    onResult(words, false);
    return true;
  }

  @override
  Future<void> stopListening() async {
    _listening = false;
    _onStopped?.call();
  }
}

// Keeps example/main.dart compiling and working.
void main() {
  testWidgets('shows the position and its country', (tester) async {
    await tester.pumpWidget(
      CcSdkDeviceExampleApp(
        location: _FakeLocation(),
        speech: const CcNoopSpeechRecognizer(),
      ),
    );

    await tester.tap(find.text('Locate me'));
    await tester.pump();

    expect(find.text('21.0285, 105.8542 (VN)'), findsOneWidget);
  });

  testWidgets('dictates, then stops', (tester) async {
    await tester.pumpWidget(
      CcSdkDeviceExampleApp(
        location: CcNoopLocationService(),
        speech: _FakeSpeech('hello world'),
      ),
    );

    await tester.tap(find.text('Dictate'));
    await tester.pump();
    expect(find.text('hello world'), findsOneWidget);

    await tester.tap(find.text('Stop'));
    await tester.pump();
    expect(find.text('Dictate'), findsOneWidget);
  });

  testWidgets('the real implementations degrade without plugins', (
    tester,
  ) async {
    await tester.pumpWidget(
      CcSdkDeviceExampleApp(
        location: CcDeviceLocationService(),
        speech: const CcNoopSpeechRecognizer(),
      ),
    );

    // The failing plugin calls complete on the real event loop.
    await tester.runAsync(() async {
      await tester.tap(find.text('Locate me'));
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();
    expect(find.text('Location unavailable'), findsOneWidget);

    await tester.tap(find.text('Dictate'));
    await tester.pump();
    expect(find.text('Speech recognition unavailable'), findsOneWidget);
  });
}
