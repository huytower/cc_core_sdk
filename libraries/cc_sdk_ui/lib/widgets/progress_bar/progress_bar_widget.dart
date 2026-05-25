import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_base_colors.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({
    Key? key,
    required this.progress,
    this.height = 8.0,
    this.backgroundColor,
    this.progressColor,
  }) : super(key: key);

  final double progress;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(
      color: backgroundColor ?? CcBaseColors.neutral70,
      borderRadius: BorderRadius.circular(height / 2),
    ),
    child: FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: progress.clamp(0.0, 1.0),
      child: Container(
        decoration: BoxDecoration(
          color: progressColor ?? CcBaseColors.info,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      ),
    ),
  );
}
