import 'dart:async';

import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// [CcSpeechRecognizer] backed by the platform recognizer (`speech_to_text`).
///
/// One instance per app (DI singleton) for the one microphone: a second
/// [startListening] during a session does not start another, so a later
/// caller cannot overwrite an earlier caller's callback and leave it stuck
/// "listening".
@LazySingleton(as: CcSpeechRecognizer)
class CcSpeechToTextRecognizer implements CcSpeechRecognizer {
  CcSpeechToTextRecognizer(this._speech);

  final SpeechToText _speech;
  bool _initialized = false;
  Future<void> _initLock = Future.value();
  void Function()? _onListeningStopped;

  static const String _tag = 'CcSpeechToTextRecognizer';

  @override
  bool get hasListening => _speech.isListening;

  /// `SpeechToText.initialize()` only keeps the callbacks of its first call,
  /// so the status listener is wired once and forwards to the latest
  /// session's `onListeningStopped`. Locked so two racing first calls cannot
  /// both initialize.
  Future<bool> _ensureInitialized() async {
    final previous = _initLock;
    final completer = Completer<void>();
    _initLock = completer.future;
    await previous;
    try {
      if (_initialized) return true;
      final ready = await _speech.initialize(
        debugLogging: true,
        onStatus: (status) {
          'Status: $status'.Log(_tag);
          if (status == SpeechToText.notListeningStatus ||
              status == SpeechToText.doneStatus) {
            _onListeningStopped?.call();
          }
        },
        onError: (error) {
          'Recognition error: ${error.errorMsg}'.Log(_tag);
          _onListeningStopped?.call();
        },
      );
      _initialized = ready;
      return ready;
    } catch (e) {
      'Initialization failed: $e'.Log(_tag);
      return false;
    } finally {
      completer.complete();
    }
  }

  @override
  Future<bool> startListening({
    required void Function(String recognizedWords, bool hasFinal) onResult,
    void Function()? onListeningStopped,
    String? localeId,
  }) async {
    'startListening | localeId=$localeId'.Log(_tag);
    if (_speech.isListening) return true;

    try {
      if (!await _ensureInitialized()) return false;
      if (_speech.isListening) return true;

      _onListeningStopped = onListeningStopped;
      await _speech.listen(
        onResult: (result) =>
            onResult(result.recognizedWords, result.finalResult),
        localeId: localeId,
        pauseFor: const Duration(seconds: 3),
        listenFor: const Duration(seconds: 45),
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
          partialResults: true,
          autoPunctuation: true,
          cancelOnError: false,
        ),
      );
      return true;
    } catch (e) {
      'Listen failed: $e'.Log(_tag);
      return false;
    }
  }

  @override
  Future<void> stopListening() async {
    final callback = _onListeningStopped;
    _onListeningStopped = null;
    try {
      if (_speech.isListening) await _speech.stop();
      callback?.call();
    } catch (e) {
      'Stop failed: $e'.Log(_tag);
    }
  }
}
