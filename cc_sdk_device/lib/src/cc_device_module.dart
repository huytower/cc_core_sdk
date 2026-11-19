import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Provides plugin instances, which have no injectable constructor.
@module
abstract class CcDeviceModule {
  @lazySingleton
  SpeechToText get speechToText => SpeechToText();
}
