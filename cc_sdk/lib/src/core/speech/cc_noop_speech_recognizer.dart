import 'cc_speech_recognizer.dart';

/// [CcSpeechRecognizer] that never listens: for tests and apps without
/// voice input.
class CcNoopSpeechRecognizer implements CcSpeechRecognizer {
  const CcNoopSpeechRecognizer();

  @override
  bool get hasListening => false;

  @override
  Future<bool> startListening({
    required void Function(String recognizedWords, bool hasFinal) onResult,
    void Function()? onListeningStopped,
    String? localeId,
  }) async => false;

  @override
  Future<void> stopListening() async {}
}

