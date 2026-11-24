# Changelog

## Unreleased

### Breaking (next release: 3.0.0)

- `DoubleBackToExitMixin` and `PaginationMixin` are `CcDoubleBackToExitMixin`
  and `CcPaginationMixin`. Migration: add the prefix (same API).
- No longer depends on `cc_sdk_ui`, `loadmore` or `custom_refresh_indicator`;
  only on `cc_sdk_data`. `CcViewConfigMixin`, `CcPullRefreshMixin`,
  `CcLoadMoreMixin` and `CcCurvedNavigationMixin` moved to `cc_sdk_ui`.
  Migration: import them from `package:cc_sdk_ui/export_cc_sdk_ui.dart`.
- `DoubleBackToExitMixin` shows its hint through the new
  `showBackPressHint(context, message)` hook, a plain `SnackBar` by default.
  Migration: to keep the design-system snackbar, override it with
  `showDoubleBackPressSnackBar(context, message)` from `cc_sdk_ui`.
- The example now uses only `cc_mixin`, `cc_sdk_data` and Flutter.

### Changed (before the move to `cc_sdk_ui`)

- `CcLoadMoreMixin.buildLoadMore` takes `isFinish` (default `false`): pass
  `!hasMore` so the footer shows "no more" and stops calling `onLoadMore`.
- Fixed: the load-more footer threw `UnimplementedError` when rebuilt while
  scrolled out of view (`LoadMoreStatus.outScreen`); it now draws nothing.
- Added `example/main.dart` (uses only SDK packages) and a test suite; `test/example_test.dart` keeps the example working.

## 2.0.0

- Version aligned with the rest of the SDK (was 1.0.0). No API change.
