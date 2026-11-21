import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

/// A reusable [LoadMoreDelegate] implementation for the cc_mixin package.
///
/// This class isolates the load-more presentation logic from the mixin, keeping
/// the mixin focused on construction and configuration.
class CcLoadMoreItem extends LoadMoreDelegate {
  const CcLoadMoreItem();

  @override
  Widget buildChild(
    LoadMoreStatus status, {
    LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.english,
  }) {
    final text = builder(status);

    switch (status) {
      case LoadMoreStatus.fail:
        return _buildText(text, color: CcBaseColors.errorRed);
      case LoadMoreStatus.idle:
        return _buildText(text, color: CcBaseColors.warningAmber);
      case LoadMoreStatus.loading:
        return _buildLoading(text);
      case LoadMoreStatus.nomore:
        return _buildText(text);
      case LoadMoreStatus.outScreen:
        // The footer is scrolled away but may still be built inside the list's
        // cache extent: draw nothing instead of failing.
        return const SizedBox.shrink();
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

  CcText _buildText(
    String text, {
    Color? color,
    TextAlign? textAlign,
    Alignment? align,
  }) {
    return CcText(
      text,
      fontSize: CcTypographyParams.bodyLarge,
      color: color ?? CcBaseColors.gray700,
      textAlign: textAlign ?? TextAlign.center,
      align: align ?? Alignment.center,
    );
  }
}
