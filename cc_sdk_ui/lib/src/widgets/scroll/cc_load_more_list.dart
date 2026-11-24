import 'package:cc_sdk_ui/src/core/config/tokens/cc_base_colors.dart';
import 'package:cc_sdk_ui/src/core/config/tokens/cc_typography_params.dart';
import 'package:cc_sdk_ui/src/widgets/flex/cc_flex.dart';
import 'package:cc_sdk_ui/src/widgets/scroll/cc_load_more_labels.dart';
import 'package:cc_sdk_ui/src/widgets/space/cc_space.dart';
import 'package:cc_sdk_ui/src/widgets/state/cc_progress_indicator.dart';
import 'package:cc_sdk_ui/src/widgets/text/cc_text.dart';
import 'package:flutter/material.dart';

/// A `ListView.builder` that loads the next page when its end comes into
/// view, with a footer for the loading / failed / finished states.
///
/// [onLoadMore] returns true on success and false on failure (the footer then
/// offers a retry). Set [hasFinish] once the source has no more data (for
/// example `!hasMore` from `CcPaginationMixin`): the footer shows
/// [CcLoadMoreLabels.noMore] and [onLoadMore] is no longer called.
///
/// ```dart
/// CcLoadMoreList(
///   itemCount: items.length,
///   itemBuilder: (_, i) => ListTile(title: Text(items[i])),
///   isFinish: !hasMore,
///   onLoadMore: loadNextPage,
/// )
/// ```
class CcLoadMoreList extends StatefulWidget {
  const CcLoadMoreList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onLoadMore,
    this.hasFinish = false,
    this.labels = const CcLoadMoreLabels(),
    this.controller,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Future<bool> Function() onLoadMore;
  final bool hasFinish;
  final CcLoadMoreLabels labels;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  State<CcLoadMoreList> createState() => _CcLoadMoreListState();
}

enum _LoadState { idle, loading, failed }

class _CcLoadMoreListState extends State<CcLoadMoreList> {
  _LoadState _state = _LoadState.idle;
  bool _scheduled = false;

  bool get _canLoad => !widget.hasFinish && _state == _LoadState.idle;

  /// Called while the footer builds: loads after this frame, once.
  void _scheduleLoad() {
    if (!_canLoad || _scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      _load();
    });
  }

  Future<void> _load() async {
    if (!mounted || !_canLoad) return;
    setState(() => _state = _LoadState.loading);
    bool succeeded;
    try {
      succeeded = await widget.onLoadMore();
    } catch (_) {
      succeeded = false;
    }
    if (!mounted) return;
    setState(() => _state = succeeded ? _LoadState.idle : _LoadState.failed);
  }

  void _retry() => setState(() => _state = _LoadState.idle);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.controller,
      padding: widget.padding,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      itemCount: widget.itemCount + 1,
      itemBuilder: (context, index) => index < widget.itemCount
          ? widget.itemBuilder(context, index)
          : _buildFooter(),
    );
  }

  Widget _buildFooter() {
    final labels = widget.labels;
    if (widget.hasFinish) return _buildText(labels.noMore);
    switch (_state) {
      case _LoadState.failed:
        return InkWell(
          onTap: _retry,
          child: _buildText(labels.failed, color: CcBaseColors.errorRed),
        );
      case _LoadState.idle:
        _scheduleLoad();
        return _buildLoading(labels.loading);
      case _LoadState.loading:
        return _buildLoading(labels.loading);
    }
  }

  Widget _buildLoading(String text) {
    return CcRowCenter(
      children: <Widget>[
        const Center(child: CcProgressIndicator(paddingTop: 0)),
        const CcSpaceLG(),
        _buildText(text),
      ],
    );
  }

  Widget _buildText(String text, {Color? color}) {
    return CcText(
      text,
      fontSize: CcTypographyParams.bodyLarge,
      color: color ?? CcBaseColors.gray700,
      textAlign: TextAlign.center,
      align: Alignment.center,
    );
  }
}
