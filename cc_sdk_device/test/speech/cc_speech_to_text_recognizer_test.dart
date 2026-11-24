import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_device/export_cc_sdk_device.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Minimal recognizer: initialize succeeds unless [available] is false;
/// listen / stop toggle [isListening].
class _FakeSpeechToText implements SpeechToText {
  _FakeSpeechToText({this.available = true});

  final bool available;
  int initializeCalls = 0;
  int listenCalls = 0;
  String? lastLocaleId;
  bool _listening = false;

  @override
  bool get isListening => _listening;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    switch (invocation.memberName) {
      case #initialize:
        initializeCalls++;
        return Future.value(available);
      case #listen:
        listenCalls++;
        lastLocaleId = invocation.namedArguments[#localeId] as String?;
        _listening = true;
        return Future<void>.value();
      case #stop:
        _listening = false;
        return Future<void>.value();
    }
    return super.noSuchMethod(invocation);
  }
}

void main() {
  test('starts one session and passes the locale', () async {
    final fake = _FakeSpeechToText();
    final CcSpeechRecognizer speech = CcSpeechToTextRecognizer(fake);

    final started = await speech.startListening(
      onResult: (_, _) {},
      localeId: 'vi_VN',
    );

    expect(started, isTrue);
    expect(speech.hasListening, isTrue);
    expect(fake.lastLocaleId, 'vi_VN');
  });

  test('a second start during a session does not listen again', () async {
    final fake = _FakeSpeechToText();
    final speech = CcSpeechToTextRecognizer(fake);

    await speech.startListening(onResult: (_, _) {});
    final again = await speech.startListening(onResult: (_, _) {});

    expect(again, isTrue);
    expect(fake.listenCalls, 1);
  });

  test('initializes only once across sessions', () async {
    final fake = _FakeSpeechToText();
    final speech = CcSpeechToTextRecognizer(fake);

    await speech.startListening(onResult: (_, _) {});
    await speech.stopListening();
    await speech.startListening(onResult: (_, _) {});

    expect(fake.initializeCalls, 1);
    expect(fake.listenCalls, 2);
  });

  test('stopListening stops and fires the session callback once', () async {
    final speech = CcSpeechToTextRecognizer(_FakeSpeechToText());
    var stopped = 0;

    await speech.startListening(
      onResult: (_, _) {},
      onListeningStopped: () => stopped++,
    );
    await speech.stopListening();
    await speech.stopListening();

    expect(speech.hasListening, isFalse);
    expect(stopped, 1);
  });

  test('returns false when the recognizer is unavailable', () async {
    final speech = CcSpeechToTextRecognizer(
      _FakeSpeechToText(available: false),
    );

    expect(await speech.startListening(onResult: (_, _) {}), isFalse);
  });
}
