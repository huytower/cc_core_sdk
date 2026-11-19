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
