import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';

class CcArrowRight extends StatelessWidget {
  const CcArrowRight({Key? key}) : super(key: key);

  @override
  Center build(BuildContext context) => Center(
    child: SizedBox(
      width: context.respDim(25.0),
      child: Icon(
        Icons.skip_next,
        color: context.ccColorScheme.onSurface,
        size: context.respIconSize(baseSize: 15.0),
      ),
    ),
  );
}
