/// Footer texts of [CcLoadMoreList]. The SDK ships English defaults; pass
/// translated strings from the app.
///
/// ```dart
/// CcLoadMoreLabels(noMore: el.tr(keys.noMoreData))
/// ```
class CcLoadMoreLabels {
  const CcLoadMoreLabels({
    this.loading = 'Loading...',
    this.failed = 'Load failed, tap to retry',
    this.noMore = 'No more data',
  });

  /// Shown while the next page loads.
  final String loading;

  /// Shown when the last load failed; tapping it retries.
  final String failed;

  /// Shown once the list is finished.
  final String noMore;
}
