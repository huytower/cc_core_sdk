import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Reports [child]'s laid-out size through [onChange] whenever it changes.
///
/// Use it when a parent must size something else from content whose height
/// is not known up front (e.g. a header whose banner may wrap). The callback
/// runs after the frame, so it is safe to `setState` in it; it fires once for
/// the first layout and again only when the size actually changes.
class CcMeasureSize extends SingleChildRenderObjectWidget {
  const CcMeasureSize({super.key, required this.onChange, super.child});

  final ValueChanged<Size> onChange;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasureSize(onChange);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMeasureSize renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class _RenderMeasureSize extends RenderProxyBox {
  _RenderMeasureSize(this.onChange);

  ValueChanged<Size> onChange;
  Size? _lastSize;

  @override
  void performLayout() {
    super.performLayout();
    final measured = size;
    if (measured == _lastSize) return;
    _lastSize = measured;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (attached) onChange(measured);
    });
  }
}
