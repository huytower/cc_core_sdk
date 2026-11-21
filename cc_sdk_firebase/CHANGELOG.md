# Changelog

## Unreleased

### Breaking (next release: 3.0.0)

- `CcFirebaseAiClient` takes a `CcFirebaseAiConfig` (new interface) instead of
  reading `CcSdkConfig.aiModelName`. Migration: register an implementation,
  e.g. `@LazySingleton(as: CcFirebaseAiConfig) class PrjFirebaseAiConfig`.
  `CcFirebaseAiClient.modelNameFrom` exposes the model-id rule.
- `CcFirebaseCrashReporter` no longer checks a global flag; it always reports.
  Migration: turn collection off with Crashlytics'
  `setCrashlyticsCollectionEnabled(false)` or register another
  `CcCrashReporter`.

### Other

- Added `example/main.dart` and tests; `test/example_test.dart` keeps the example working. `firebase_core` is a dev dependency, used only by the example.

## 2.0.0

- First release, split out of `cc_sdk` so that apps which do not use this
  capability do not pull its dependencies. Provides `CcFirebaseAiClient`, `CcFirebaseAnalytics`, `CcFirebaseCrashReporter` and `CcFirebaseAppAttestation`.
