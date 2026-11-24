# Changelog

## Unreleased

### Breaking (next release: 3.0.0)

- Failures carry the `Cc` prefix: `CcServerFailure`, `CcCacheFailure`,
  `CcNetworkFailure`, `CcDeviceFailure`, `CcUnauthorizedFailure`,
  `CcUnknownFailure`, `CcValidationFailure`; `PaginationRequest` is
  `CcPaginationRequest`. Migration: add the prefix (same API).
- Removed `BiometricFailure` and `CurlFailure` (unused, feature- and
  tool-named). Migration: declare them in the app as `CcFailure` subclasses.
- No Flutter dependency at runtime: the package is pure Dart, and the example
  is a console program. `CcFailure` stays open (not `sealed`) because apps and
  micro-features add their own failures.

### Other

- Added `example/main.dart` (uses only SDK packages) and a test suite; `test/example_test.dart` keeps the example working.

## 2.0.0

- Version aligned with the rest of the SDK (was 1.0.0+1). No API change.
