# Changelog

## Unreleased

- `CcLoadMoreMixin.buildLoadMore` takes `isFinish` (default `false`): pass
  `!hasMore` so the footer shows "no more" and stops calling `onLoadMore`.
- Fixed: the load-more footer threw `UnimplementedError` when rebuilt while
  scrolled out of view (`LoadMoreStatus.outScreen`); it now draws nothing.

- Added `example/main.dart` (uses only SDK packages) and a test suite; `test/example_test.dart` keeps the example working.

## 2.0.0

- Version aligned with the rest of the SDK (was 1.0.0). No API change.
