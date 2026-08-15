import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart';

/// On-device speech-to-text, encapsulated so callers never need a direct
/// `speech_to_text` dependency of their own (same convention as
/// [CcLocationHelper] wrapping `geolocator`). Fails silently on any error —
/// this backs an optional "quick voice entry" affordance, never something
/// that should crash or block a form.
///
/// This whole class is a static/global singleton, but callers (e.g.
/// multiple `ExpenseFormController` instances — the persistent entry-tab
/// one plus a separately-tagged one per open edit sheet) are not. There's
/// only one physical microphone, so [startListening] deliberately refuses a
/// second concurrent session rather than silently letting a later caller's
/// [startListening]'s `onListeningStopped` callback overwrite an earlier
/// caller's — without that guard, the earlier caller would never be told
/// its session ended, reproducing the exact "stuck listening" bug this
/// class exists to prevent, just via a different trigger.
class CcSpeechHelper {
  CcSpeechHelper._();

  static final SpeechToText _speech = SpeechToText();
  static bool _initialized = false;
  static Future<void> _initLock = Future.value();
  static void Function()? _onListeningStopped;

  static bool get isListening => _speech.isListening;

  /// `SpeechToText.initialize()` only captures the `onStatus`/`onError`
  /// callbacks passed on its *first* successful call — every later call
  /// short-circuits (`if (_initWorked) return Future.value(_initWorked);`
  /// inside the package) and silently ignores whatever new callbacks were
  /// passed. So the status listener is wired up exactly once here, as a
  /// stable indirection that always forwards to whichever callback the most
  /// recent [startListening] call registered. Serialized behind
  /// [_initLock] (same Future-chaining mutex pattern as
  /// `AiFallbackPreferenceDataSource.tryConsumeDailyCall`) so two
  /// first-ever calls racing each other can't both see [_initialized] as
  /// false and both kick off a platform `initialize()` call.
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

  /// Starts listening, streaming interim and final transcriptions to
  /// [onResult]. Requests the mic/speech-recognition permission the first
  /// time it's called. Returns false if initialization or permission
  /// fails, **or if a listening session is already active** — only one
  /// caller can hold the mic at a time (see class doc).
  ///
  /// [onListeningStopped] fires whenever the platform recognizer stops
  /// listening for *any* reason — not just when [onResult] delivers a final
  /// result. Callers that track an "is listening" UI flag should reset it
  /// here rather than only from `onResult`'s `isFinal`, since the
  /// recognizer can stop itself (e.g. a silence timeout) without ever
  /// producing a final result, which would otherwise leave the UI stuck
  /// showing "listening" indefinitely.
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
