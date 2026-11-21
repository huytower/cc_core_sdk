# Changelog

## Unreleased

### Breaking (next release: 3.0.0)

- Widget-building mixins moved here from `cc_mixin`: `CcViewConfigMixin`,
  `CcPullRefreshMixin`, `CcLoadMoreMixin`, `CcCurvedNavigationMixin`.
  Migration: import them from `package:cc_sdk_ui/export_cc_sdk_ui.dart`.
- `showDoubleBackPressSnackBar` moved here from `cc_mixin`; use it from
  `DoubleBackToExitMixin.showBackPressHint`.
- No longer depends on `loadmore`. `CcLoadMoreMixin.buildLoadMore` now takes
  `itemCount` + `itemBuilder` (plus optional `labels`, `controller`,
  `padding`, `physics`) instead of a `child` list, and builds the new
  `CcLoadMoreList`. `CcLoadMoreItem` is removed. Migration: pass the item
  count and builder of the former `ListView.builder`.
- No longer depends on `curved_navigation_bar_pro`: the bar is adapted into
  `lib/src/widgets/navigation/curved/` (MIT notice kept), same look. Removed
  `CcCurvedNavigationBar.navbarStyle` and
  `CcCurvedNavigationMixin.navbarStyle` (a `dynamic` preset nobody set).
  Migration: set the colors and sizes directly.
- `CcCurvedNavigationItem` moved to its own file (same barrel, no change for
  callers).

### Added

- `CcLoadMoreList` and `CcLoadMoreLabels` (translated footer texts).
- `environment.flutter` constraint, like the other SDK packages.

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
