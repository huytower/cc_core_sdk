# Changelog

## Unreleased

### Breaking (next release: 3.0.0)

- Methods that answer yes/no use the `has` prefix too: `isAtLeast` / `isBelow` (window size classes) -> `hasAtLeast` / `hasBelow`, `isSmallTablet` -> `hasSmallTablet`, `isScrollingToEnd` / `isScrollingClickStart` / `isScrollingClickEnd` -> `has...`.
  Migration: rename the calls.
- Booleans use the `has` prefix instead of `is` (root `AGENTS.md`
  rule 12): `isLoading` -> `hasLoading`, `isVisible` -> `hasVisible`, `isDark` -> `hasDark`, `isCurved` -> `hasCurved`, and every other `isX`. Migration: rename the references (same behaviour).
- Abbreviations are spelled out: `bgColor` -> `backgroundColor`,
  `defaultBgColor` -> `defaultBackgroundColor`, `isCancelBtnShown` ->
  `hasCancelButtonShown`, `isActionBtnVisible` -> `hasActionButtonVisible`.
  Migration: rename the named arguments.
- Every public widget carries the `Cc` prefix and no abbreviation:
  `CcErrorPage`, `CcLoadingPage`, `CcEmptyPage`, `CcFadeWidget`,
  `CcFadePageWrapper`, `CcHorizontalFadeScrollView`, `CcAppNameWidget`,
  `CcSocialLoginType`, `CcCurvedBarView`, `CcCurvedBubble`, `CcCurvedBadge`,
  `CcCurvedNavigationTile` (was `CurvedNavTile`), `CcCurvedNotchPainter`;
  `BgGradientWidget` is `CcGradientBackground`; the `*Btn` buttons are
  `*Button` (`CcBaseButton`, `CcBackButton`, `CcCancelButton`,
  `CcClearButton`, `CcCloseButton`, `CcCopyButton`, `CcNextButton`,
  `CcSocialLoginButton`, `CcActionButtonInDialog`). Migration: rename the
  references (same API).
- Renamed `CcPullRefreshMixin` to `CcPullToRefreshMixin` and
  `CcInteractBtnWrapper` to `CcInteractionWrapper`, so each class matches its
  file name. Migration: rename the references (same API).
- No longer depends on `cc_sdk` and no longer re-exports
  `package:cc_sdk/export_cc_sdk.dart`, so the design system pulls no device,
  network or storage plugin. Migration: files that use `.Log()`, `getIt`,
  helpers or capability interfaces import `package:cc_sdk/export_cc_sdk.dart`
  as well.
- `CcScale` and `CcWindowSizeClass` / `CcWindowHeightClass` moved here from
  `cc_sdk` (same API, exported from this barrel).
- Removed `CcRewardCompletionBanner` and `CcGuidelineBadge` (a showcase banner
  and an app's onboarding badge). Migration: keep a copy in the app.
- Errors caught by `CcWidgetHelper.markNeedsBuild` and the confirmation dialog
  of `CcDialogHelper` go to `FlutterError.reportError` instead of `.Log()`.
- Widget-building mixins moved here from `cc_mixin`: `CcViewConfigMixin`,
  `CcPullToRefreshMixin`, `CcLoadMoreMixin`, `CcCurvedNavigationMixin`.
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

- `CcAdaptiveBottomSheet.show` (modal sheet narrowed and centred from a small
  tablet up) and `CcAdaptiveBottomSheet.constraintsFor`.
- `CcTwoColumnPair`: one or two cards side by side on a landscape tablet,
  stacked elsewhere.
- `CcShimmerList`: horizontal row of shimmering tiles for loading pickers.
- `CcScrollReveal.reveal`: centres an item of a horizontal row.
- `CcGradientBackground.page(child:)`: a page body over a faint, even tint.
- Form building blocks: `CcNumericKeypad` (3 × 4 number pad, optional `000`
  key), `CcKeypadPanel` (keypad + quick picks + clear / copy / done, texts in
  `CcKeypadLabels`), `CcQuickValueChips` / `CcQuickValue` (formatted quick-pick
  chips), `CcFormCard`, `CcFormTwoColumn` (landscape-tablet entry form),
  `CcSubmitButton` (spinner, badge, gradient).
- Dates: `CcQuickDateRow` (today / yesterday / calendar), `CcDatePickerSheet`
  with `CcCalendarMonthGrid` and `CcYearGrid`. Month, weekday and button texts
  come from `MaterialLocalizations`; the first weekday follows the locale
  unless `firstDayOfWeekIndex` is given.
- `CcLoadMoreList` and `CcLoadMoreLabels` (translated footer texts).
- `environment.flutter` constraint, like the other SDK packages.

### Added

- Added `example/main.dart` and tests; `test/example_test.dart` keeps the example working.

### Changed

- `CcDialogHelper.showModalBottomSheet` and `showMessageBottomSheet` now use
  `CcAdaptiveBottomSheet`: from a small tablet up the sheet is 480 dp wide and
  centred instead of Material's 640 dp. Phones are unchanged.
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
