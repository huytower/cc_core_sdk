import 'package:flutter/cupertino.dart';

import '../../../core/theme/base_colors.dart';

class PageLoading extends StatelessWidget {
  const PageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CupertinoActivityIndicator(radius: 15, color: BaseColors.info),
      ),
    );
  }
}
