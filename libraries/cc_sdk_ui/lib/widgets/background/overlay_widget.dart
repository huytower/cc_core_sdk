import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_base_colors.dart';

class OverlayWidget extends StatelessWidget {
  const OverlayWidget({Key? key, this.color, this.opacity = 0.5})
    : super(key: key);

  final Color? color;
  final double opacity;

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: Container(
      color: (color ?? Theme.of(context).colorScheme.surfaceVariant)
          .withOpacity(opacity),
    ),
  );
}
