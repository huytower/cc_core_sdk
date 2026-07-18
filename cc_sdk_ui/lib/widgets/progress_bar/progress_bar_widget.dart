import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_border_radius.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({
    Key? key,
    required this.progress,
    this.height,
    this.backgroundColor,
    this.progressColor,
  }) : super(key: key);

  final double progress;

  /// Responsive track height. Defaults to a width-scaled 8pt so the bar stays
  /// proportional across screen sizes instead of a fixed pixel value.
  final double? height;
  final Color? backgroundColor;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    final trackHeight = height ?? context.respDim(8.0);
    return Container(
      height: trackHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.ccColorScheme.surfaceVariant,
        borderRadius: context.brCircle,
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: progressColor ?? context.ccColorScheme.primary,
            borderRadius: context.brCircle,
          ),
        ),
      ),
    );
  }
}
