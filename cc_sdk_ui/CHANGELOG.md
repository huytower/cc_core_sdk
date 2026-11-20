# Changelog

## Unreleased

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
