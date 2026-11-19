/// Device-capability implementations of cc_sdk interfaces.
///
/// Consumers depend on the interfaces from `cc_sdk` (e.g.
/// `CcSpeechRecognizer`); the app registers this package's DI module so they
/// resolve to the implementations here.
library;

export 'package:cc_sdk_device/src/speech/cc_speech_to_text_recognizer.dart';
