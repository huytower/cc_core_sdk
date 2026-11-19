# Changelog

## 2.0.0

Vendor SDKs move out of the core into capability packages. `cc_sdk` keeps only
the interfaces, so an app that does not use a vendor no longer pulls it in.

### Breaking

- **Analytics:** `CcAnalyticsHelper` (static, Firebase-only) is removed and
  `firebase_analytics` is no longer a dependency of `cc_sdk`.
  - New interface `CcAnalytics` (plus `CcNoopAnalytics`) in `cc_sdk`.
  - Firebase implementation `CcFirebaseAnalytics` in the new package
    `cc_sdk_firebase`, registered in DI as `CcAnalytics`.
  - Migration:
    1. Depend on `cc_sdk_firebase` and add
       `ExternalModule(CcSdkFirebasePackageModule)` to the app's
       `externalPackageModulesBefore`.
    2. Inject `CcAnalytics` instead of calling `CcAnalyticsHelper.*`
       (in micro-packages, add `CcAnalytics` to `ignoreUnregisteredTypes`).
    3. `CcAnalyticsHelper.observer` -> `analytics.navigatorObserver`
       (nullable); `logSignUp(signUpMethod:)` -> `logSignUp(method:)`.
- **Crash reporting:** `CcCrashReportingHelper` and `CcCrashlyticsHandler`
  (Firebase-only) are removed and `firebase_crashlytics` is no longer a
  dependency of `cc_sdk`.
  - New interface `CcCrashReporter` (plus `CcNoopCrashReporter` and the
    Catcher2 `CcCrashReporterHandler`) in `cc_sdk`.
  - Firebase implementation `CcFirebaseCrashReporter` in `cc_sdk_firebase`,
    registered as `CcCrashReporter`.
  - Migration: `CcCrashReportingHelper.recordHandledError(e, st, reason:)` ->
    `crashReporter.recordError(e, st, reason:)`; `.log(m)` ->
    `crashReporter.log(m)`. `CcCatcherBootstrap.*Options(logFile)` no longer
    adds Crashlytics on its own: pass `crashReporter: getIt<CcCrashReporter>()`.
- **App Check:** `CcAppCheckHelper` (Firebase-only) is removed and
  `firebase_app_check` is no longer a dependency of `cc_sdk`.
  - New interface `CcAppAttestation` (plus `CcNoopAppAttestation`) in
    `cc_sdk`; Firebase implementation `CcFirebaseAppAttestation` in
    `cc_sdk_firebase`, registered as `CcAppAttestation`.
  - Migration: `CcAppCheckHelper.initialize()` -> `attestation.activate()`;
    `getAppCheckStatus()` -> `statusDescription()`; `getToken()` /
    `refreshToken()` -> `getToken(forceRefresh:)`; `setAutoRefresh` /
    `setAppCheckEnabled` -> `setTokenAutoRefresh`.
  - `CcSlackHandler` no longer reads App Check itself: pass
    `attestation:` to it or to `CcCatcherBootstrap.releaseOptions` /
    `profileOptions` (reports show `n/a` otherwise).
- **AI (Gemini):** `CcGeminiHelper` (static, Firebase-only) and the re-exported
  Firebase `Schema` / `SchemaType` are removed; `firebase_ai` is no longer a
  dependency of `cc_sdk`.
  - New `CcAiClient.generate(prompt:, images:, responseSchema:)` returning
    `CcAiResult` (text or a `CcAiFailure` with a kind, e.g.
    `deviceAttestation`), plus the vendor-neutral `CcAiSchema` (same builders
    as Firebase `Schema`) and `CcAiImage`.
  - Firebase implementation `CcFirebaseAiClient` in `cc_sdk_firebase`
    (retries transient 5xx, reports final failures to `CcCrashReporter`).
  - Model: `CcSdkConfig(aiModelName:)` replaces
    `CcGeminiHelper.configure(modelName:)`.
  - Migration: `Schema.x(...)` -> `CcAiSchema.x(...)`;
    `generateText` / `generateFromImages` -> `generate(images:)`;
    `lastError` -> `CcAiResult.failure` (or `CcAiClient.lastFailure`);
    string checks for App Check errors -> `CcAiFailureKind.deviceAttestation`.
    `generateFromImage` (single image, unused) is gone.
- **Slack:** `CcSlackFeedbackHelper` and `CcSlackHandler` leave `cc_sdk` for
  the new package `cc_sdk_slack`; `cc_sdk` keeps only the interfaces.
  - New `CcFeedbackReporter.send(CcFeedback, labels: CcFeedbackLabels)` (plus
    `CcNoopFeedbackReporter`) in `cc_sdk`; `CcSlackFeedbackReporter` in
    `cc_sdk_slack`. The 5-language captions that were hardcoded in the SDK
    now come from the app as `CcFeedbackLabels`.
  - `CcSlackHandler` (now in `cc_sdk_slack`) takes `webhookUrl:` (required);
    the static `configure` methods are gone.
  - `CcCatcherBootstrap.releaseOptions` / `profileOptions` no longer add
    Slack themselves: pass `remoteHandlers: [CcSlackHandler(...)]`. Their
    `attestation:` parameter is removed (give it to `CcSlackHandler`).
- **Speech:** `CcSpeechHelper` (static) is removed and `speech_to_text` is no
  longer a dependency of `cc_sdk`.
  - New interface `CcSpeechRecognizer` (plus `CcNoopSpeechRecognizer`) in
    `cc_sdk`; implementation `CcSpeechToTextRecognizer` in the new package
    `cc_sdk_device`, registered as `CcSpeechRecognizer`
    (`ExternalModule(CcSdkDevicePackageModule)`).
  - `localeId` no longer defaults to `vi_VN`: pass it, or null for the
    device default.
- **Location:** `CcLocationHelper` (static, exposing geolocator `Position`)
  is removed; `geolocator`, `geocoding` and `permission_handler` are no longer
  dependencies of `cc_sdk`.
  - New `CcGeoPosition` (with plugin-free haversine `distanceTo` /
    `distanceBetweenMeters`, same Earth radius as geolocator) and the
    `CcLocationService` interface (plus `CcNoopLocationService`):
    `lastPosition`, `requestPermission`, `hasPermission`,
    `getCurrentPosition`, `getLastKnownPosition`, `countryCodeAt` (reverse
    geocoding, replaces calling `Geocoding()` directly).
  - Implementation `CcDeviceLocationService` in `cc_sdk_device`.
  - Removed without replacement (unused, phone-specific):
    `countryPhoneCodes`, `defaultCountryCode` (`+84`), `getCountryCode`,
    `getCountryCodeFromLocation`.
- **Phone:** `phone_numbers_parser` is no longer a dependency of `cc_sdk`;
  `CcPhoneNumberHelper` keeps only the dependency-free `autoParsePhoneNumber`
  and `flagEmoji`.
  - New interface `CcPhoneNumberValidator` (`isValidMobile`,
    `formatInternational`) with the dependency-free
    `CcBasicPhoneNumberValidator` (E.164 shape) in `cc_sdk`, and
    `CcLibPhoneNumberValidator` (per-country rules) in the new package
    `cc_sdk_phone`.
  - Migration: `CcPhoneNumberHelper.isValidPhoneNumber(n)` ->
    `validator.isValidMobile(n)`; `formatPhoneNumber(n)` ->
    `validator.formatInternational(n)`; `getCountryCode` (unused) is gone.
  - `CcPhoneNumberInput` / `CcCountryCodeSelector` stay in `cc_sdk_ui`
    (they never needed the parser).
- **Removed (deprecated in 1.x):** `CcReceiptScanHelper`, `PickedReceiptImage`,
  `ReceiptPickResult`, `ReceiptBatchPickResult`, and with them the
  `google_mlkit_text_recognition` and `image_picker` dependencies. Pick images
  in the app (or a capability package).
- **Dependencies:** `deep_collection` is dropped (`ccWhen` behaves the same).
  `cc_sdk` now has 15 runtime dependencies (was 27), none of them a vendor
  service SDK.

### Added (since 1.0.0, non-breaking)

- `CcSdkConfig` (typed settings via `CcSdkConfig.configure()`); the SDK no
  longer reads `.env` files and no longer depends on `flutter_dotenv`.
- `configure(...)` on `CcSlackHandler`, `CcSlackFeedbackHelper`,
  `CcGeminiHelper`.

### Deprecated (removed in the next major version)

- `CcFeatureFlags.isVipModeEnabled`.
- `CcWalletItem`, `CcCategoryItem`, `CcCategoryChip`,
  `CcCategoryGroupSection`, `CcCategoryGroupItem`, `CcCategoryShimmerList`.
- `CcReceiptScanHelper`, `PickedReceiptImage`, `ReceiptPickResult`,
  `ReceiptBatchPickResult`.
