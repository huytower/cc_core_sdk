# cc_sdk_firebase

Firebase implementations of `cc_sdk` capability interfaces. Code depends on the
interfaces only; this package is the one place that imports Firebase SDKs.

| Interface (`cc_sdk`) | Implementation | Firebase SDK |
|---|---|---|
| `CcAiClient` | `CcFirebaseAiClient` (Gemini) | `firebase_ai` |
| `CcAnalytics` | `CcFirebaseAnalytics` | `firebase_analytics` |
| `CcCrashReporter` | `CcFirebaseCrashReporter` | `firebase_crashlytics` |
| `CcAppAttestation` | `CcFirebaseAppAttestation` | `firebase_app_check` |

## Setup

1. Add `cc_sdk_firebase` (path dependency) to the app.
2. Add `ExternalModule(CcSdkFirebasePackageModule)` to the app's
   `externalPackageModulesBefore` (import
   `package:cc_sdk_firebase/core/di/di.module.dart`).
3. Inject the interface, e.g. `CcAnalytics`, where it is needed.
4. Register `CcCrashReporter` yourself: `CcFirebaseCrashReporter` is registered
   as itself only, so the app decides whether reports go to Crashlytics alone
   or to several services, e.g.
   `CcCompositeCrashReporter([firebaseReporter, slackReporter])` in an app
   `@module`. `CcFirebaseAiClient` needs that registration.


An app that does not use Firebase skips this package and registers its own
implementation (or `CcNoopAnalytics`) as `CcAnalytics`.
