# Changelog

## Unreleased

### Changed

- No longer depends on the `get` package. `CcKeyboardHelper` without a
  `BuildContext` now uses `FocusManager` (`showKeyboard` focuses in the root
  focus scope, `hideKeyboard` unfocuses the primary focus) instead of
  `Get.context` / `Get.focusScope`. Apps that use GetX declare `get`
  themselves.

### Deprecated (removed in 3.0.0)

- `CcWidgetHelper.getBoxFitType`: guesses the device model from width and
  bottom padding. Choose the `BoxFit` from the space given (`LayoutBuilder` /
  `CcWindowSizeClass`).
