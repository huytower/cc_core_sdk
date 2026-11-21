# Changelog

## Unreleased

### Added

- Added `example/main.dart` and tests; `test/example_test.dart` keeps the example working.

### Changed

- No longer depends on the `get` package. `CcKeyboardHelper` without a
  `BuildContext` now uses `FocusManager` (`showKeyboard` focuses in the root
  focus scope, `hideKeyboard` unfocuses the primary focus) instead of
  `Get.context` / `Get.focusScope`. Apps that use GetX declare `get`
  themselves.

### Breaking

- Removed `CcWidgetHelper.getBoxFitType` (guessed the device model from width
  and bottom padding), without a deprecation release: nothing in this
  workspace called it. Migration: choose the `BoxFit` from the space given
  (`LayoutBuilder` / `CcWindowSizeClass`).

## 2.0.0

- Version aligned with the rest of the SDK (was 1.0.0). No API change.
