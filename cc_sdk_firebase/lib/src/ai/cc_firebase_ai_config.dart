/// Settings for [CcFirebaseAiClient], supplied by the app through DI.
///
/// The app registers one implementation, so the model id comes in through the
/// client's constructor rather than a global:
///
/// ```dart
/// @LazySingleton(as: CcFirebaseAiConfig)
/// class PrjFirebaseAiConfig implements CcFirebaseAiConfig {
///   @override
///   String get modelName => PrjEnv.geminiModelName;
/// }
/// ```
abstract interface class CcFirebaseAiConfig {
  /// Gemini model id, with or without the `gemini-` prefix; blank uses
  /// [CcFirebaseAiClient.defaultModelName].
  String get modelName;
}
