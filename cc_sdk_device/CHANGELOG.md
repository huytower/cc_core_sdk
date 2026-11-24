# Changelog

## Unreleased

### Breaking (next release: 3.0.0)

- Booleans use the `has` prefix instead of `is` (root `AGENTS.md`
  rule 12): `hasListening`, `hasFinal`. Migration: rename the references (same behaviour).

### Other

- Added `CcUdidDeviceIdProvider` (registered as `CcDeviceIdProvider`):
  `identifierForVendor` on iOS/macOS, the `flutter_udid` UDID elsewhere,
  `''` on failure. `flutter_udid` and `device_info_plus` are now dependencies
  of this package (the UDID left `cc_sdk`). Register `CcSdkDevicePackageModule`
  after `CcSdkPackageModule`.
- Added `example/main.dart` and tests; `test/example_test.dart` keeps the example working.

## 2.0.0

- First release, split out of `cc_sdk` so that apps which do not use this
  capability do not pull its dependencies. Provides `CcDeviceLocationService` (as `CcLocationService`) and `CcSpeechToTextRecognizer` (as `CcSpeechRecognizer`).
