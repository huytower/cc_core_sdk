import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart';

/// On-device speech-to-text, encapsulated so callers never need a direct
/// `speech_to_text` dependency. Fails silently on any error.
///
/// This class is a static/global singleton, but callers aren't — there's
/// only one physical microphone, so [startListening] refuses a second
/// concurrent session rather than letting a later caller's callback
/// silently overwrite an earlier caller's and leave it stuck "listening".
class CcSpeechHelper {
  CcSpeechHelper._();

  static final SpeechToText _speech = SpeechToText();
  static bool _initialized = false;
  static Future<void> _initLock = Future.value();
  static void Function()? _onListeningStopped;

  static bool get isListening => _speech.isListening;

  /// `SpeechToText.initialize()` only captures its callbacks on the *first*
  /// call, so the status listener is wired up once here and always forwards
  /// to whichever [startListening] call registered most recently. Locked so
  /// two racing first-ever calls can't both kick off `initialize()`.
  static Future<bool> _ensureInitialized() async {
    final previous = _initLock;
    final completer = Completer<void>();
    _initLock = completer.future;
    await previous;
    try {
      if (_initialized) return true;
      final ready = await _speech.initialize(
        debugLogging: true,
        onStatus: (status) {
          if (status == SpeechToText.notListeningStatus ||
              status == SpeechToText.doneStatus) {
            _onListeningStopped?.call();
          }
        },
      );
      _initialized = ready;
      return ready;
    } finally {
      completer.complete();
    }
  }

  /// Streams transcriptions to [onResult]. Returns false if init/permission
  /// fails or a session is already active (see class doc).
  ///
  /// [onListeningStopped] fires whenever the recognizer stops for *any*
  /// reason, not just a final result — the recognizer can stop itself (e.g.
  /// a silence timeout), so UI "is listening" state should reset here too,
  /// not only from `onResult`'s `isFinal`.
  static Future<bool> startListening({
    required void Function(String recognizedWords, bool isFinal) onResult,
    void Function()? onListeningStopped,
    String localeId = 'vi_VN',
  }) async {
    if (_speech.isListening) return false;
    try {
      final ready = await _ensureInitialized();
      if (!ready) return false;
      // Re-check after the awaited initialize() — another caller could
      // have started (and even finished) a session while this one was
      // waiting its turn to initialize.
      if (_speech.isListening) return false;
      _onListeningStopped = onListeningStopped;
      await _speech.listen(
        listenOptions: SpeechListenOptions(localeId: localeId),
        onResult: (result) =>
            onResult(result.recognizedWords, result.finalResult),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> stopListening() async {
    try {
      await _speech.stop();
    } catch (_) {
      // Best-effort — nothing more to do if the platform call fails.
    }
  }
}
