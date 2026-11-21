# Changelog

## Unreleased

- Added `example/main.dart` and tests; `test/example_test.dart` keeps the example working. `firebase_core` is a dev dependency, used only by the example.

## 2.0.0

- First release, split out of `cc_sdk` so that apps which do not use this
  capability do not pull its dependencies. Provides `CcFirebaseAiClient`, `CcFirebaseAnalytics`, `CcFirebaseCrashReporter` and `CcFirebaseAppAttestation`.
