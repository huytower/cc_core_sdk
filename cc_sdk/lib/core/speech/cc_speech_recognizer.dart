/// Speech-to-text from the microphone, independent of any vendor.
///
/// The SDK core only defines this contract. An implementation comes from a
/// capability package (e.g. `CcSpeechToTextRecognizer` in `cc_sdk_device`),
/// registered in DI as `CcSpeechRecognizer`. Implementations never throw.
///
/// There is one microphone, so a second [startListening] while a session is
/// active does not start another one.
///
/// ```dart
/// final started = await speech.startListening(
///   localeId: 'en_US',
///   onResult: (words, isFinal) => field.text = words,
///   onListeningStopped: submit,
/// );
/// ```
abstract interface class CcSpeechRecognizer {
  bool get isListening;

  /// Streams transcriptions to [onResult]. Returns false if the recognizer
  /// cannot start (no permission, unavailable). Returns true without a new
  /// session if one is already active.
  ///
  /// [onListeningStopped] fires whenever listening stops for any reason
  /// (final result, silence timeout, error), so UI state can reset there.
  /// [localeId] such as `vi_VN`; null uses the device's default.
  Future<bool> startListening({
    required void Function(String recognizedWords, bool isFinal) onResult,
    void Function()? onListeningStopped,
    String? localeId,
  });

  /// Stops the current session (if any) and fires its `onListeningStopped`.
  Future<void> stopListening();
}

/// [CcSpeechRecognizer] that never listens: for tests and apps without
/// voice input.
class CcNoopSpeechRecognizer implements CcSpeechRecognizer {
  const CcNoopSpeechRecognizer();

  @override
  bool get isListening => false;

  @override
  Future<bool> startListening({
    required void Function(String recognizedWords, bool isFinal) onResult,
    void Function()? onListeningStopped,
    String? localeId,
  }) async => false;

  @override
  Future<void> stopListening() async {}
}
