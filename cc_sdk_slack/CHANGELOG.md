# Changelog

## Unreleased

- Fixed the alert time: it mixed a 24-hour hour with AM/PM (`22:19 PM`); it
  is now a 12-hour clock (`10:19 PM`). Catcher2 alerts (`CcSlackHandler`)
  show the device's real UTC offset instead of a fixed `(GMT+7)`.
- Added `CcSlackCrashReporter`, a `CcCrashReporter` that posts each recorded
  error (caught or uncaught) to a Slack webhook, with app version, device and
  App Check state. It shares a 5-minute duplicate throttle with
  `CcSlackHandler`, so an error reaching both is posted once.
- Added `example/main.dart` and tests; `test/example_test.dart` keeps the example working.

## 2.0.0

- First release, split out of `cc_sdk` so that apps which do not use this
  capability do not pull its dependencies. Provides `CcSlackHandler` (crash alerts) and `CcSlackFeedbackReporter` (as `CcFeedbackReporter`).
