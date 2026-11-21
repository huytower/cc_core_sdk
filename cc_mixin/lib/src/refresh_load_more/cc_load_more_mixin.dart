import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

import 'cc_load_more_item.dart';

/// Mixin providing a reusable load-more wrapper.
///
/// The mixin is intentionally focused on construction and configuration.
/// The indicator presentation is extracted to [CcLoadMoreItem].
///
/// Pass [isFinish] once the source has no more data (for example
/// `!hasMore` from `PaginationMixin`): the footer then shows the "no more"
/// state and [onLoadMore] is no longer called.
///
/// [child] must be a `ListView` or `SliverList`. Prefer `ListView.builder`:
/// with `ListView(children: ...)` the `loadmore` package appends its footer to
/// that list, so it must not be `const`.
///
/// ```dart
/// buildLoadMore(
///   isFinish: !hasMore,
///   onLoadMore: loadNextPage,
///   child: ListView(children: items),
/// )
/// ```
mixin CcLoadMoreMixin {
  Widget buildLoadMore({
    required Future<bool> Function() onLoadMore,
    required Widget child,
    bool isFinish = false,
  }) {
    LoadMoreDelegate.buildWidget = () => const CcLoadMoreItem();

    return LoadMore(
      delegate: LoadMoreDelegate.buildWidget(),
      textBuilder: DefaultLoadMoreTextBuilder.english,
      isFinish: isFinish,
      onLoadMore: onLoadMore,
      child: child,
    );
  }
}
