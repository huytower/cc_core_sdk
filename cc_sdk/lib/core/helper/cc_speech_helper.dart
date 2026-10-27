import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart';

import '../extensions/common/cc_logger_extension.dart';

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
          '[CcSpeechHelper] Status changed: $status'.Log('CcSpeechHelper');
          if (status == SpeechToText.notListeningStatus ||
              status == SpeechToText.doneStatus) {
            _onListeningStopped?.call();
          }
        },
        onError: (error) {
          '[CcSpeechHelper] Speech recognition error: ${error.errorMsg}'.Log(
            'CcSpeechHelper',
          );
          _onListeningStopped?.call();
        },
      );
      _initialized = ready;
      return ready;
    } catch (e) {
      '[CcSpeechHelper] Speech recognition initialization failed: $e'.Log(
        'CcSpeechHelper',
      );
      return false;
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
    '[CcSpeechHelper] startListening requested | localeId=$localeId'.Log(
      'CcSpeechHelper',
    );

    if (_speech.isListening) {
      '[CcSpeechHelper] Speech recognizer is already listening'.Log(
        'CcSpeechHelper',
      );
      return true;
    }

    try {
      final ready = await _ensureInitialized();
      if (!ready) {
        '[CcSpeechHelper] Speech recognizer initialization failed'.Log(
          'CcSpeechHelper',
        );
        return false;
      }

      if (_speech.isListening) return true;

      _onListeningStopped = onListeningStopped;
      await _speech.listen(
        onResult: (result) {
          '[CcSpeechHelper] onResult: "${result.recognizedWords}" | isFinal=${result.finalResult}'
              .Log('CcSpeechHelper');
          onResult(result.recognizedWords, result.finalResult);
        },
        localeId: localeId,
        pauseFor: const Duration(seconds: 3),
        listenFor: const Duration(seconds: 45),
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
          partialResults: true,
          autoPunctuation: true,
        ),
        cancelOnError: false,
        partialResults: true,
      );
      return true;
    } catch (e) {
      '[CcSpeechHelper] Listen exception: $e'.Log('CcSpeechHelper');
      return false;
    }
  }

  static Future<void> stopListening() async {
    '[CcSpeechHelper] stopListening requested'.Log('CcSpeechHelper');
    final callback = _onListeningStopped;
    _onListeningStopped = null;
    try {
      if (_speech.isListening) {
        await _speech.stop();
      }
      callback?.call();
    } catch (e) {
      '[CcSpeechHelper] Stop exception: $e'.Log('CcSpeechHelper');
    }
  }
}
