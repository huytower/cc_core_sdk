import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../text/cc_text.dart';

class DurationWidget extends StatelessWidget {
  const DurationWidget({Key? key, required this.duration}) : super(key: key);

  final String duration;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(4),
    ),
    child: CcText(
      duration,
      fontSize: 12,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}
