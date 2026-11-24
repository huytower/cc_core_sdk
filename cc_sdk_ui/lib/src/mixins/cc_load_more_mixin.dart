import 'package:cc_sdk_ui/src/widgets/scroll/cc_load_more_labels.dart';
import 'package:cc_sdk_ui/src/widgets/scroll/cc_load_more_list.dart';
import 'package:flutter/material.dart';

/// Mixin providing a list that loads the next page at its end
/// ([CcLoadMoreList]).
///
/// Pass [isFinish] once the source has no more data (for example `!hasMore`
/// from `CcPaginationMixin`): the footer then shows the "no more" state and
/// [onLoadMore] is no longer called.
///
/// ```dart
/// buildLoadMore(
///   itemCount: items.length,
///   itemBuilder: (_, i) => ListTile(title: Text(items[i])),
///   isFinish: !hasMore,
///   onLoadMore: loadNextPage,
/// )
/// ```
mixin CcLoadMoreMixin {
  Widget buildLoadMore({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    required Future<bool> Function() onLoadMore,
    bool hasFinish = false,
    CcLoadMoreLabels labels = const CcLoadMoreLabels(),
    ScrollController? controller,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
  }) {
    return CcLoadMoreList(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      onLoadMore: onLoadMore,
      hasFinish: hasFinish,
      labels: labels,
      controller: controller,
      padding: padding,
      physics: physics,
    );
  }
}
